defmodule NanoCi.Repo.Migrations.BuildRevisionField do
  use Ecto.Migration

  def change do
    alter table(:builds) do
      add :revision, :string
    end
  end
end
