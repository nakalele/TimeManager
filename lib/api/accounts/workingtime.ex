defmodule Api.Accounts.Workingtime do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workingtimes" do
    field :end, :time
    field :start, :time
    field :date, :date
    field :total, :time
    field :user, :id
    timestamps()
  end

  @doc false
  def changeset(workingtime, attrs) do
    workingtime
    |> cast(attrs, [:start, :end, :date, :total, :user])
    |> validate_required([:start, :end, :date, :total, :user])
  end
end
