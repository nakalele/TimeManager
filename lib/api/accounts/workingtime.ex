defmodule Api.Accounts.Workingtime do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workingtimes" do
    field :end, :time
    field :start, :time
    field :date, :date
    field :total, :time
    field :user, :id
    field :teams, :integer
    timestamps()
  end

  @doc false
  def changeset(workingtime, attrs) do
    workingtime
    |> cast(attrs, [:start, :end, :date, :total, :user, :teams])
    |> validate_required([:start, :end, :date, :total, :user, :teams])
  end
end
