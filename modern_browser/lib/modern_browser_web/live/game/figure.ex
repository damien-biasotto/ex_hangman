defmodule ModernBrowserWeb.Live.Game.Figure do
  use Phoenix.LiveComponent

  def mount (socket) do
    {:ok, socket}
  end 

  def render(assigns) do
    ~H"""
    <div class="flex-1">
      <h3>Figure</h3>
    </div>
    """
  end 
end 