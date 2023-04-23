defmodule Dictionary.Impl.WordList do 
  
  @type t :: list(String.t)

  @spec word_list :: t
  def word_list() do
    System.get_env("DICTIONARY_FILEPATH")
    |> File.read!  
    |> String.split("\n", trim: true)
  end 

  @spec random_word(t) :: String.t 
  def random_word(words) do
    words |> Enum.random
  end
end 
