defmodule NanoCi.Repo.Migrations.AddBuild do
  use Ecto.Migration

  def change do
    create table(:builds) do
      add :status, :string
      add :build_log, :text

      timestamps()
    end
  end
end
