defmodule Api.Repo.Migrations.UpdateWokingtime3 do
  use Ecto.Migration

  def change do
    alter table("workingtimes") do
      remove :start, :naive_datetime
      remove :end, :naive_datetime
      add :start, :time
      add :end, :time
      add :teams, :int
    end
  end
end
