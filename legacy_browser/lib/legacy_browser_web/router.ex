defmodule LegacyBrowserWeb.Router do
  use LegacyBrowserWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {LegacyBrowserWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/hangman", LegacyBrowserWeb do
    pipe_through :browser

    get "/", HangmanController, :index
    post "/new", HangmanController, :new
  end

  # Other scopes may use custom stacks.
  # scope "/api", LegacyBrowserWeb do
  #   pipe_through :api
  # end
end
