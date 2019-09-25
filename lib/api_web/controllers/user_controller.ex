defmodule ApiWeb.UserController do
  use ApiWeb, :controller

  alias Api.Accounts
  alias Api.Accounts.User

  action_fallback ApiWeb.FallbackController

  alias Api.Guardian


  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Accounts.token_sign_in(email, password) do
      {:ok, token, _claims} ->
        conn |> render("jwt.json", jwt: token)
      _ ->
        {:error, :unauthorized}
    end
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn |> render("jwt.json", jwt: token)
    end
  end

  def show_id(conn, %{"userID" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "user.json", user: user)
  end

  def show_all(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def show_by_email(conn, %{}) do
    params = conn.query_params

    # check that there an email and an username params
    if Map.has_key?(params, "email") and Map.has_key?(params, "username") do
      user = Accounts.get_user_by_email!(Map.get(params, "email"), Map.get(params, "username")) # get the user by attributes
      render(conn, "show.json", user: user)
    end
  end

  def show(conn, _params) do
     user = Guardian.Plug.current_resource(conn)
     conn |> render("user.json", user: user)
  end

  def update(conn, %{"userID" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"userID" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
