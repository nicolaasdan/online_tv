defmodule OnlineTv.Router do
  use OnlineTv.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug OnlineTv.Auth, repo: OnlineTv.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", OnlineTv do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/schedule", PageController, :schedule
    get "/about", PageController, :about
    resources "/users", UserController, only: [:new, :create, :index, :show]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  scope "/manage", OnlineTv do
    pipe_through [:browser, :authenticate_user]

    resources "/videos", VideoController
  end

  # Other scopes may use custom stacks.
  # scope "/api", OnlineTv do
  #   pipe_through :api
  # end
end
