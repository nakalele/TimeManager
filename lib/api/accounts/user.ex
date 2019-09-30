defmodule Api.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  import EctoEnum
  defenum RolesEnum, :role, [:employee, :manager, :admin]
  @derive {Jason.Encoder, only: [:id, :email, :username, :firstname, :lastname, :role, :teams]}

import Comeonin.Bcrypt, only: [hashpwsalt: 1]



  schema "users" do
    field :email, :string
    field :username, :string
    field :firstname, :string
    field :lastname, :string
    field :password_hash, :string
    field :role, RolesEnum
    field :teams, :integer
    has_many :workingtimes, Api.Accounts.Workingtime
    # Virtual fields:
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @required_fields ~w()
  @required_fields ~w(email username firstname lastname password_hash role)



  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username, :password, :firstname, :lastname, :password_confirmation, :role, :teams])
    |> validate_required([:email, :username, :firstname, :lastname, :password, :password_confirmation, :role, :teams])
    |> validate_format(:email, ~r/@/) # Check that email is valid
    |> validate_length(:password, min: 8) # Check that password length is >= 8
    |> validate_confirmation(:password) # Check that password === password_confirmation
    |> unique_constraint(:email)
    |> put_password_hash
  end
  defp put_password_hash(changeset) do
   case changeset do
     %Ecto.Changeset{valid?: true, changes: %{password: pass}}
       ->
         put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
     _ ->
         changeset
   end
 end
end

