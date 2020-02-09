defmodule NanoCi.Build do
  use Ecto.Schema
  alias NanoCi.GitRepo
  import Ecto.Changeset

  schema "builds" do
    belongs_to :repo, GitRepo
    field :status, :string
    field :revision, :string
    field :build_log, :string

    timestamps()
  end

  @doc false
  def changeset(%NanoCi.Build{} = build, attrs) do
    build
    |> cast(attrs, [:status, :build_log, :revision])
  end
end
