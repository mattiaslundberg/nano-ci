defmodule NanoCiWeb.Router do
  use NanoCiWeb, :router

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

  scope "/", NanoCiWeb do
    pipe_through :browser

    resources "/", PageController, only: [:index, :show, :create]
  end

  scope "/api", NanoCiWeb do
    pipe_through :api

    resources "/build", BuildController, only: [:create, :show, :index]
    resources "/github", GithubController, only: [:create]
  end
end
