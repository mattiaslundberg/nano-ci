defmodule NanoCi.GitRepo do
  use Ecto.Schema
  import Ecto.Changeset
  alias NanoCi.Build

  schema "gitrepo" do
    field :name, :string
    field :git_url, :string
    field :view_url, :string
    field :ssh_key, :string
    field :build, :boolean, default: true
    has_many :builds, Build

    timestamps()
  end

  @doc false
  def changeset(%NanoCi.GitRepo{} = repo, attrs) do
    repo
    |> cast(attrs, [:name, :git_url, :view_url, :build, :ssh_key])
  end
end
