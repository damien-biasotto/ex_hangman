defmodule LegacyBrowserWeb.HangmanController do
  use LegacyBrowserWeb, :controller

  def index(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :index, layout: false)
  end

  def new(conn, _params) do
    game = Hangman.new_game()

    conn
    |> put_session(:game, game)
    |> redirect(to: ~p"/hangman/current")
  end

  def update(conn, params) do
    guess = params["make_move"]["guess"]
    
    put_in(conn.params["make_move"]["guess"], "") 
      |> get_session(:game)
      |> Hangman.make_move(guess)


    redirect(conn, to: ~p"/hangman/current")
  end

  def show(conn, params) do
    tally =
      conn
      |> get_session(:game)
      |> Hangman.tally()

    render(conn, :game, layout: false, tally: tally)
  end 
end
