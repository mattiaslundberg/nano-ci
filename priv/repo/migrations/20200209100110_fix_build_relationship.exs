defmodule NanoCi.Repo.Migrations.FixBuildRelationship do
  use Ecto.Migration

  def change do
    alter table(:gitrepo) do
      remove :builds
    end

    alter table(:builds) do
      add :repo, references(:gitrepo)
    end
  end
end
