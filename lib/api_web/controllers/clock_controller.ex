defmodule ApiWeb.ClockController do
  use ApiWeb, :controller

  alias Api.Accounts
  alias Api.Accounts.Clock

  action_fallback ApiWeb.FallbackController

  def index(conn, _params) do
    clocks = Accounts.list_clocks()
    render(conn, "index.json", clocks: clocks)
  end

  def create(conn, %{"clock" => clock_params}) do
    with {:ok, %Clock{} = clock} <- Accounts.create_clock(clock_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.clock_path(conn, :show, clock))
      |> render("show.json", clock: clock)
    end
  end

  def show(conn, %{"userID" => id}) do
    clock = Accounts.get_clock!(id)
    render(conn, "show.json", clock: clock)
  end

  def update(conn, %{"userID" => id, "clock" => clock_params}) do
    clock = Accounts.get_clock!(id)

    with {:ok, %Clock{} = clock} <- Accounts.update_clock(clock, clock_params) do
      render(conn, "show.json", clock: clock)
    end
  end

  def delete(conn, %{"userID" => id}) do
    clock = Accounts.get_clock!(id)

    with {:ok, %Clock{}} <- Accounts.delete_clock(clock) do
      send_resp(conn, :no_content, "")
    end
  end
end
