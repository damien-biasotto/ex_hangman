defmodule ModernBrowserWeb.Live.Game do 
  use ModernBrowserWeb, :live_view
  
  def mount(_params, _session, socket) do 
    hangman_game = Hangman.new_game()
    tally = Hangman.tally(hangman_game)
    socket = socket |> assign(%{game: hangman_game, tally: tally})
    {:ok, socket}
  end

  def handle_event("make_move", %{ "key" => key }, socket) do
    tally = Hangman.make_move(socket.assigns.game, key)
    { :noreply, assign(socket, :tally, tally) }
  end 
  
  def render(assigns) do
    ~H"""
    <div class="flex" phx-window-keyup="make_move">
      <.live_component module={__MODULE__.Figure}, tally={@tally} id="figure") />
      <div class="flex-row">
        <.live_component module={__MODULE__.Alphabet} tally={@tally} id="alphabet" />
        <.live_component module={__MODULE__.WordSoFar} tally={@tally} id="word-so-far"/>
      </div>
    </div>
    """
  end 
end 