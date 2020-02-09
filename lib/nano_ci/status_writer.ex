defmodule NanoCi.StatusWriter do
  use GenServer
  alias NanoCi.{Repo, Build}

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def set_status(build, status) do
    GenServer.cast(__MODULE__, {:set_status, build, status})
  end

  ## Callbacks

  @impl true
  def init(_) do
    {:ok, nil}
  end

  @impl true
  def handle_cast({:set_status, build, status}, state) do
    {:ok, _} = build |> Build.changeset(%{status: status}) |> Repo.update()
    {:noreply, state}
  end
end
