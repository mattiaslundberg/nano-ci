defmodule NanoCi.Builder.Controller do
  use GenServer
  alias NanoCi.Builder.Runner

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
  def handle_cast({:start_build, repo, build}, state) do
    {:ok, pid} = Runner.start_link(repo, build)
    {:noreply, Map.put(state, build.id, pid)}
  end
end
