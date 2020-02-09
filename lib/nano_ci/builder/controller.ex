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
  def handle_info({:get_output, build}, state) do
    {_pid, ref} = Map.get(state, build.id, {nil, nil})

    case Runner.get_status(ref) do
      {:ok, output} ->
        StatusWriter.set_output(build, output)

        schedule(build, 1000)
        {:noreply, state}

      x ->
        IO.inspect(x)
        {:noreply, Map.delete(state, build.id)}
    end
  end

  @impl true
  def handle_cast({:start_build, repo, build}, state) do
    {:ok, pid, ref} = Runner.start_link(repo, build)
    schedule(build, 1000)
    {:noreply, Map.put(state, build.id, {pid, ref})}
  end

  defp schedule(build, check_interval) do
    Process.send_after(self(), {:get_output, build}, check_interval)
  end
end
