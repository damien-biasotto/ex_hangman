defmodule LegacyBrowserWeb.HangmanController do
  use LegacyBrowserWeb, :controller

  def index(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :index, layout: false)
  end

  def new(conn, _params) do
    render(conn, :new, layout: false)
  end
end
