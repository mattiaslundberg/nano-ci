defmodule NanoCi.Builder.Controller do
  use GenServer
  alias NanoCi.Builder.Runner
  alias NanoCi.StatusWriter

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def start_build(repo, build) do
    GenServer.cast(__MODULE__, {:start_build, repo, build})
  end

  ## Callbacks

  @impl true
  def init(_) do
    {:ok, %{}}
  end

  @impl true
  def handle_info({:timeout, build}, state) do
    {runner_pid, status_pid, _} = Map.get(state, build.id, {nil, nil})
    StatusWriter.set_status(build, "timeout")
    Process.exit(runner_pid, :timeout)
    Process.exit(status_pid, :timeout)
    {:noreply, Map.delete(state, build.id)}
  end

  @impl true
  def handle_cast({:start_build, repo, build}, state) do
    {:ok, runner_pid, ref} = Runner.start_link(repo, build)
    sw = %StatusWriter{build: build}
    {:ok, status_pid} = Task.start_link(fn -> Runner.get_status(ref, sw) end)
    Process.send_after(self(), {:timeout, build}, 10_000_000)
    {:noreply, Map.put(state, build.id, {runner_pid, status_pid, ref})}
  end
end
