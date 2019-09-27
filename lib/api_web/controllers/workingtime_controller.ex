defmodule ApiWeb.WorkingtimeController do
  use ApiWeb, :controller

  alias Api.Accounts
  alias Api.Accounts.Workingtime

  action_fallback ApiWeb.FallbackController

  def index(conn, _params) do
    workingtimes = Accounts.list_workingtimes()
    render(conn, "index.json", workingtimes: workingtimes)
  end

  def create(conn, %{"workingtime" => workingtime_params}) do
    with {:ok, %Workingtime{} = workingtime} <- Accounts.create_workingtime(workingtime_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.workingtime_path(conn, :show, workingtime))
      |> render("show.json", workingtime: workingtime)
    end
  end

  def show(conn, %{"userID" => id}) do
    workingtime = Accounts.get_workingtime!(id)
    render(conn, "show.json", workingtime: workingtime)
  end

  def show_all(conn, _params) do
    workingtimes = Accounts.list_workingtimes()
    render(conn, "index.json", workingtimes: workingtimes)
  end

  def showId(conn, %{"userID" => userId, "workingtimeID" => workId}) do
    workingtime = Accounts.get_workingtime_byId!(userId, workId)
    render(conn, "show.json", workingtime: workingtime)
  end

  #def show_id(conn, %{"userID" => id, "workingtimeID" => workingtime}) do
  #  workingtime = 

  def update(conn, %{"id" => id, "workingtime" => workingtime_params}) do
    workingtime = Accounts.get_workingtime!(id)

    with {:ok, %Workingtime{} = workingtime} <- Accounts.update_workingtime(workingtime, workingtime_params) do
      render(conn, "show.json", workingtime: workingtime)
    end
  end

  def delete(conn, %{"id" => id}) do
    workingtime = Accounts.get_workingtime!(id)

    with {:ok, %Workingtime{}} <- Accounts.delete_workingtime(workingtime) do
      send_resp(conn, :no_content, "")
    end
  end
end
