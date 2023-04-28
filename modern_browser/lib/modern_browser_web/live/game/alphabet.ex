defmodule ModernBrowserWeb.Live.Game.Alphabet do
  use ModernBrowserWeb, :live_component

  def mount(socket) do
    letters =
      ?a..?z
      |> Enum.map(&<<&1::utf8>>)

    {:ok, assign(socket, :alphabets, letters)}
  end

  defp classOf(letter, tally) do
    base_css = "cursor-pointer w-10 h-10 text-2xl p-3"

    cond do
      Enum.member?(tally.letters, letter) -> "#{base_css} text-emerald-400"
      Enum.member?(tally.used, letter) -> "#{base_css} text-amber-400"
      true -> base_css
    end
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-row flex-wrap pr-24 my-16">
      <%= for letter <- assigns.alphabets do %>
        <div class={classOf(letter, assigns.tally)} phx-click="make_move" phx-value-key={letter}>
          <%= letter %>
        </div>
      <% end %>
    </div>
    """
  end
end
