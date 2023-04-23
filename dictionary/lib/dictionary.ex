defmodule Dictionary do
  @moduledoc """
  Documentation for `Dictionary`.
  """

  @doc """
  ## Examples

      iex> Dictionary.word_list()
      ["foo", "bar", ...]

  """

  @word_list System.get_env("DICTIONARY_FILEPATH")
    |> File.read!  
    |> String.split("\n", trim: true)

  def random_word do
    @word_list
    |> Enum.random
  end

end
