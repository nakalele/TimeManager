defmodule Api.Repo.Migrations.UpdateWokingtime2 do
  use Ecto.Migration

  def change do
    alter table("workingtimes") do
      remove :total_hours, :naive_datetime
      add :total, :time
    end
  end
end
