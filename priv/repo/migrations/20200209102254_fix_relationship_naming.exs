defmodule NanoCi.Repo.Migrations.FixRelationshipNaming do
  use Ecto.Migration

  def change do
    alter table(:builds) do
      remove :repo
      add :repo_id, references(:gitrepo)
    end
  end
end
