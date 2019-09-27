defmodule ApiWeb.Router do
  use ApiWeb, :router

  alias Api.Guardian

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end


  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :jwt_authenticated do
     plug Guardian.AuthPipeline
   end

  scope "/", ApiWeb do
    pipe_through :browser

    get "/", PageController, :index
  end


  scope "/api", ApiWeb do
    pipe_through :api



  scope "/sign_up"do
    post "/", UserController, :create
  end

  scope "/sign_in"do
    post "/", UserController, :sign_in
  end




    scope "/users" do
      get "/", UserController, :show_all
      get "/:userID", UserController, :show_id
      post "/", UserController, :create
      put "/:userID", UserController, :update
      delete "/:userID", UserController, :delete
    end

    scope "/workingtimes" do
      get "/", WorkingtimeController, :show_all
      get "/:userID",WorkingtimeController , :show
      get "/:userID/:workingtimeID", WorkingtimeController, :showId
      post "/:userID", WorkingtimeController, :create
      put "/:id", WorkingtimeController, :update
      delete "/:id", WorkingtimeController, :delete
    end

    scope "/clocks" do
      get "/:userID", ClockController, :show
      post "/:userID", ClockController, :create
    end
  end
  scope "/api", ApiWeb do
    pipe_through [:api, :jwt_authenticated]

    get "/my_user", UserController, :show
  end

end
