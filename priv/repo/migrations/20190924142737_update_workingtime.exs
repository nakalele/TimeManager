defmodule Api.Repo.Migrations.UpdateWorkingtime do
  use Ecto.Migration

  def change do
    alter table("workingtimes") do
      add :total_hours, :naive_datetime
    end
  end
end
