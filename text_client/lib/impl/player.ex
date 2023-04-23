defmodule TextClient.Impl.Player do 

  @typep game :: Hangman.game 
  @typep tally :: Hangman.tally
  @typep state :: { game, tally }
  
  @spec start() :: :ok
  def start() do
    game = Hangman.new_game()
    tally = Hangman.tally(game)    

    interact({game, tally})
  end 

  def interact({_game, _tally = %{game_state: :won}}) do
    IO.puts "Congratulations. You won!"
  end
  
  def interact({_game, tally = %{game_state: :lost}}) do
    IO.puts "Sorry, you lost. The word was \"#{tally.letters |> Enum.join}\"."
  end

  @spec interact(state) :: :ok
  def interact({ game, tally }) do
    Enum.map([feedback(tally), current_word(tally)], &IO.puts/1)
  
    Hangman.make_move(game, get_guess()) 
    |> interact()
  end
  
  defp feedback(tally = %{game_state: :initializing}) do
    "Welcome, I'm thinking of a #{tally.letters |> length} letter word"
  end 

  defp feedback(%{game_state: :good_guess}), do: "Good guess!"
  defp feedback(%{game_state: :bad_guess}), do: "Sorry that letter is not in the word"
  defp feedback(%{game_state: :already_used}), do: "You already used that letter"

  defp current_word(tally) do
    [
      "Word so far: ", tally.letters |> Enum.join(" "),
      "  turns left: ", tally.turns_left |> to_string,
      "  used so far: ", tally.used |> Enum.join(","),
    ]
  end

  defp maybe_get_guess(char, _isChar = true), do: char 
  defp maybe_get_guess(char, _isChar = false) do
    IO.puts "Input \"#{char}\" is invalid. Try again."
    get_guess() 
  end 
  
  defp get_guess() do 
    guess = IO.gets("Next letter: ")
      |> String.trim()
      |> String.downcase()
      |> String.at(0)
      maybe_get_guess(guess, Regex.match?(~r/[a-z]/, guess))
  end 
end 