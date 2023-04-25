defmodule LegacyBrowserWeb.HangmanHTML do
  use LegacyBrowserWeb, :html

  embed_templates "hangman_html/*"

  def plural(1, word), do: "1 #{word}"

  def plural(n, word) do
    "#{n} #{word}s"
  end
end
