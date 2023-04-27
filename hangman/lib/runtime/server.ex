defmodule Hangman.Runtime.Server do 
  use GenServer 

  alias Hangman.Runtime.Watchdog 
  @idle_timeout  1 * 60 * 60 * 1000 
  
  alias Hangman.Impl.Game
  @type t :: pid
  
  def start_link(_args) do 
    GenServer.start_link(__MODULE__, nil)
  end 
  
  def init(_) do
    watcher = Watchdog.start(@idle_timeout)
    { :ok, {Game.new_game, watcher }}
  end 

  def handle_call({ :make_move, guess }, _from, { game, watcher }) do
    { updated_game, tally } = Game.make_move(game, guess)
    Watchdog.alive(watcher)
    { :reply, tally, { updated_game, watcher } }
  end

  def handle_call({ :tally }, _from, { game, watcher }) do
    Watchdog.alive(watcher)
    { :reply, Game.tally(game), { game, watcher } }
  end
  
end 
