defmodule ModernBrowserWeb.Live.Game.WordSoFar do
  use ModernBrowserWeb, :live_component

  @states %{
    already_used: "You already picked that letter",
    bad_guess:  "That's not in the word",
    good_guess: "Good guess!",
    lost: "Sorry, you lost...",
    won: "You won!",
    initializing: "Type or click on your first guess",
  }

  def mount (socket) do
    {:ok, socket}
  end 

  defp state_name(state) do
    @states[state] || "Unknown state"
  end

  defp classOf(ch) do 
    base_css = "text-2xl px-3 flex"
    cond do
      ch == "_" -> base_css
      true -> "#{base_css} text-emerald-400"
    end
  end 
  
  def render(assigns) do
    ~H"""
    <div class="flex flex-col">
      <h3><%= state_name @tally.game_state %></h3>
      <div class="flex flex-row">
        <%= for ch <- @tally.letters do %>
          <div class={classOf ch}>
            <%= ch %>
          </div>
        <% end %>
      </div>
    </div>
    """
  end 
end 