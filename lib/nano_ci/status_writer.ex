defmodule NanoCi.StatusWriter do
  use GenServer
  alias NanoCi.{Repo, Build}

  defstruct [:build]

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def set_status(build, status) do
    GenServer.cast(__MODULE__, {:set_status, build, status})
  end

  def set_output(build, output) do
    GenServer.cast(__MODULE__, {:set_output, build, output})
  end

  def update(%__MODULE__{build: build}, output) do
    GenServer.cast(__MODULE__, {:append_output, build, output})
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

  @impl true
  def handle_cast({:set_output, build, output}, state) do
    {:ok, _} = build |> Build.changeset(%{build_log: output}) |> Repo.update()
    {:noreply, state}
  end

  @impl true
  def handle_cast({:append_output, build, output}, state) do
    {:ok, _} = build |> Build.changeset(%{build_log: build.output <> output}) |> Repo.update()
    {:noreply, state}
  end
end

defimpl Collectable, for: NanoCi.StatusWriter do
  @impl true
  def into(original) do
    collector_fun = fn
      prev, {:cont, new} ->
        NanoCi.StatusWriter.update(prev, new)

      prev, :done ->
        prev

      _set, :halt ->
        :ok
    end

    {original, collector_fun}
  end
end
