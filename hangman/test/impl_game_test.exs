defmodule HangmanImplGameTest do
  
  use ExUnit.Case
  alias Hangman.Impl.Game 

  test "new game has some default values" do
    game = Game.new_game() 

    assert game.turns_left == 7 
    assert game.game_state == :initializing
    assert length(game.letters) > 0
    assert MapSet.size(game.used) == 0
  end

  test "new game returns the word as a list of letters" do
    game = Game.new_game("noah")
    assert game.letters == ["n", "o", "a", "h"]     
  end 

  test "state doesn't change if a game is won" do
    game = Game.new_game("noah")
    game = Map.put(game, :game_state, :won)

    {actual, _tally} = Game.make_move(game, "x")
    assert game == actual
  end
  
  test "state doesn't change if a game is lost" do
    game = Game.new_game("noah")
    game = Map.put(game, :game_state, :lost)

    {actual, _tally} = Game.make_move(game, "x")
    assert game == actual
  end

  test "make_move should decrease the turns on wrong guess" do
    game = Game.new_game("noah")
    { game, _tally } = Game.make_move(game, "n")
    assert 7 == game.turns_left
    { game, _tally } = Game.make_move(game, "b")
    assert 6 == game.turns_left
   end

  test "make_move should register the letter being used" do 
      game = Game.new_game("noah")
    { game, _tally } = Game.make_move(game, "n")
    assert MapSet.new(["n"])== game.used
    { game, _tally } = Game.make_move(game, "o")
    assert MapSet.new(["n", "o"])== game.used
  end

  test "make_move should detected already used letters" do
     game = Game.new_game("noah")
    { game, _tally } = Game.make_move(game, "n")
    assert MapSet.new(["n"])== game.used
    { game, _tally } = Game.make_move(game, "o")
    assert MapSet.new(["n", "o"])== game.used
    { game, _tally } = Game.make_move(game, "n")
    assert :already_used == game.game_state
  end

  test "Losing a game" do
    [
      # guess | state | turns_left | letters | used
      [ "b", :bad_guess, 6, ["_", "_", "_", "_"], ["b"]],
      [ "a", :good_guess, 6, ["_", "_", "a", "_"], ["a", "b"]],
      [ "o", :good_guess, 6, ["_", "o", "a", "_"], ["a", "b", "o"]],
      [ "b", :already_used, 6, ["_", "o", "a", "_"], ["a", "b", "o" ]],
      [ "t", :bad_guess, 5, ["_", "o", "a", "_"], ["a", "b", "o", "t"]],
      [ "h", :good_guess, 5, ["_", "o", "a", "h"], ["a", "b", "h", "o", "t"]],
      [ "r", :bad_guess, 4, ["_", "o", "a", "h"], ["a", "b", "h", "o", "r", "t"]],
      [ "e", :bad_guess, 3, ["_", "o", "a", "h"], ["a", "b", "e", "h", "o", "r", "t" ]],
      [ "w", :bad_guess, 2, ["_", "o", "a", "h"], ["a", "b", "e", "h", "o", "r", "t", "w"]],
      [ "q", :bad_guess, 1, ["_", "o", "a", "h"], ["a", "b", "e", "h", "o", "q", "r", "t", "w"]],
      [ "z", :lost, 0, ["n", "o", "a", "h"], ["a", "b", "e", "h", "o", "q", "r", "t", "w", "z"]],
    ] |> test_sequence_of_moves()
  end 
  
  test "Winning a game" do
    [
      # guess | state | turns_left | letters | used
      [ "b", :bad_guess, 6, ["_", "_", "_", "_"], ["b"]],
      [ "a", :good_guess, 6, ["_", "_", "a", "_"], ["a", "b"]],
      [ "o", :good_guess, 6, ["_", "o", "a", "_"], ["a", "b", "o"]],
      [ "b", :already_used, 6, ["_", "o", "a", "_"], ["a", "b", "o" ]],
      [ "t", :bad_guess, 5, ["_", "o", "a", "_"], ["a", "b", "o", "t" ]],
      [ "h", :good_guess, 5, ["_", "o", "a", "h"], ["a", "b", "h", "o", "t"]],
      [ "n", :won, 5, ["n", "o", "a", "h"], ["a", "b", "h", "n", "o", "t"]],
    ] |> test_sequence_of_moves()
  end

  defp test_sequence_of_moves(script) do 
    game = Game.new_game("noah")
    Enum.reduce(script, game, &check_one_move/2)
  end 

  defp check_one_move([ guess, state, turns_left, letters, used], game) do
    { game, tally } = Game.make_move(game, guess)

    assert tally.game_state == state 
    assert tally.turns_left == turns_left 
    assert tally.letters == letters
    assert tally.used == used 
    
    game
  end 
end