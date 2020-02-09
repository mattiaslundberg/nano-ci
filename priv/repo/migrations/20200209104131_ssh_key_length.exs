defmodule NanoCi.Repo.Migrations.SshKeyLength do
  use Ecto.Migration

  def change do
    alter table(:gitrepo) do
      modify :ssh_key, :text
    end
  end
end
