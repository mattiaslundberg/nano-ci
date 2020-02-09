defmodule NanoCi.Repo.Migrations.AddRepo do
  use Ecto.Migration

  def change do
    create table(:gitrepo) do
      add :name, :string
      add :git_url, :string
      add :view_url, :string
      add :ssh_key, :string
      add :build, :boolean, default: true

      timestamps()
    end
  end
end
