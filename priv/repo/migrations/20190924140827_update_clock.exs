defmodule Api.Repo.Migrations.UpdateClock do
  use Ecto.Migration

  def change do
    alter table("clocks") do
      add :departure, :naive_datetime
      add :arrival, :naive_datetime
    end
  end
end
