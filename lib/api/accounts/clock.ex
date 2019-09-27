defmodule Api.Accounts.Clock do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clocks" do
    field :status, :boolean, default: false
    field :user, :id
    field :departure, :naive_datetime
    field :arrival, :naive_datetime

    timestamps()
  end

  @doc false
  def changeset(clock, attrs) do
    clock
    |> cast(attrs, [:status, :user, :departure, :arrival])
    |> validate_required([:status, :user, :departure, :arrival])
  end
end
