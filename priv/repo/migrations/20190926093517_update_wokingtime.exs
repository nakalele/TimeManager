defmodule Api.Repo.Migrations.UpdateWorkingtime do
  use Ecto.Migration
  
  def change do
    alter table("workingtimes") do
      add :date, :date
      add :total_hours, :time
    end
  end  
end
