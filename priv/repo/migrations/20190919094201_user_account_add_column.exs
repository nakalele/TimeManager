defmodule Api.Repo.Migrations.UserAccountAddColumn do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :firstname, :string
      add :lastname, :string
      add :password_hash, :string
      add :teams, :int
    end
  end
end
