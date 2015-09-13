defmodule Roxie.Router do
  use Roxie.Web, :router

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

  pipeline :session_api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug Roxie.UserSessionPlug
  end

  pipeline :master_api do
    plug :accepts, ["json"]
    plug Roxie.MasterKeyPlug
  end

  scope "/", Roxie do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", Roxie do
    pipe_through :api

    resources "/ticket", EasyTicketController, only: [:show], singleton: true
  end

  scope "/master", Roxie do
    pipe_through :master_api

    resources "/ticket", TicketController, only: [:show], singleton: true
  end

end
