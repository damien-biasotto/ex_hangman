defmodule Hangman.Impl.Game do
  alias Hangman.Types

  @type t :: %__MODULE__{
    turns_left: integer,
    game_state: Types.state,
    letters: list(String.t),
    used: MapSet.t(String.t),
  }
  
  defstruct(
    turns_left: 7,
    game_state: :initializing,
    letters: [],
    used: MapSet.new()
  )

  def new_game do
    Dictionary.random_word
    |> new_game
  end
   
  def new_game(word) do
    %__MODULE__{
      letters: word |> String.codepoints
    } 
  end

  @spec make_move(t, String.t) :: {t, Types.tally }
  def make_move(game = %{game_state: state }, _guess) when state in [:lost, :won] do
    game |> return_with_tally
  end
  

  def make_move(game, guess) do
    accept_guess(game, guess, MapSet.member?(game.used, guess))
    |> return_with_tally
  end  
  

  defp return_with_tally (game) do
    { game, tally(game) }
  end 

  defp accept_guess(game, _guess, _already_used = true) do
    %{ game | game_state: :already_used }
  end
  
  defp accept_guess(game, guess, _already_used) do
    %{ game | used: MapSet.put(game.used, String.downcase guess) }
    |> score_guess(Enum.member?(Enum.map(game.letters, String.downcase), String.downcase guess))
  end
  
  defp score_guess(game, _good_guess = true) do
    %{ game | game_state: maybe_won?(MapSet.subset?(MapSet.new(game.letters), game.used)) }
  end
  
  defp score_guess(game = %{turns_left:  1},_good_guess = false)do 
    %{ game | game_state: :lost, turns_left: 0 } 
  end
  
  defp score_guess(game, _good_guess = false ) do 
    %{ game | turns_left: game.turns_left - 1, game_state: :bad_guess } 
  end
  
  defp maybe_won?(_won = true) do
    :won 
  end
  
  defp maybe_won?(_won) do
    :good_guess
  end
  
  @spec tally(t) :: Types.tally
  def tally(game) do
    %{
      turns_left: game.turns_left,
      game_state: game.game_state,
      letters: reveal_guessed_letters(game),
      used: game.used |> MapSet.to_list |> Enum.sort
    }
  end

  defp reveal_guessed_letters(game = %{game_state: :lost}) do
    game.letters 
  end
  
  defp reveal_guessed_letters(game) do
    game.letters 
    |> Enum.map(fn letter -> MapSet.member?(game.used, letter) |> maybe_reveal(letter) end)
  end

  defp maybe_reveal(_should_reveal = true, letter), do: letter 
  defp maybe_reveal(_, _letter), do: "_"
end 
