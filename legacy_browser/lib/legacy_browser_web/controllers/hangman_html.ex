defmodule LegacyBrowserWeb.HangmanHTML do
  use LegacyBrowserWeb, :html

  import Phoenix.HTML.Form
  import Phoenix.HTML.Link
  
  embed_templates "hangman_html/*"

    def figure_for(0) do
    ~s{
      ┌───┐
      │   │
      O   │
     /|\\  │
     / \\  │
          │
    ══════╧══
    }
  end
  def figure_for(1) do
    ~s{
      ┌───┐
      │   │
      O   │
     /|\\  │
     /    │
          │
    ══════╧══
    }
  end

  def figure_for(2) do
    ~s{
    ┌───┐
    │   │
    O   │
   /|\\  │
        │
        │
  ══════╧══
}
  end

  def figure_for(3) do
    ~s{
    ┌───┐
    │   │
    O   │
   /|   │
        │
        │
  ══════╧══
}
  end

  def figure_for(4) do
    ~s{
    ┌───┐
    │   │
    O   │
    |   │
        │
        │
  ══════╧══
}
  end

  def figure_for(5) do
    ~s{
    ┌───┐
    │   │
    O   │
        │
        │
        │
  ══════╧══
}
  end

  def figure_for(6) do
    ~s{
    ┌───┐
    │   │
        │
        │
        │
        │
  ══════╧══
}
  end

  def figure_for(7) do
    ~s{
    ┌───┐
        │
        │
        │
        │
        │
  ══════╧══
    }
  end


  @status_fields %{
     initializing: { "bg-sky-100 text-sky-600", "Guess the word, a letter at a time" },
     good_guess: { "bg-blue-100 text-blue-600", "Good guess!"},
     bad_guess: { "bg-yellow-100 text-yellow-600", "Sorry, that's a bad guess"},
     won: {"bg-emerald-100 text-emerald-600", "You won!" },
     lost: {"bg-rose-100 text-rose-600", "Sorry, you lost."},
     already_used: {"bg-amber-100 text-amber-600", "You already used that letter."},
   }
  
  def move_status(status) do
    { class, msg } = @status_fields[status]
      ~s{
	<div class="my-4 rounded-lg px-6 py-5 text-base #{class}">
           #{msg}
        </div>
      } |> raw()
  end


  def continue_or_try_again(_conn, status) when status in [:won, :lost]  do
    link("Try again", to: ~p"/hangman", method: "POST", csrf_token: {get_csrf_token()}, class: "mt-6 sm:mt-10 bg-slate-900 hover:bg-slate-700 focus:outline-none focus:ring-2 focus:ring-slate-400 focus:ring-offset-2 focus:ring-offset-slate-50 text-white font-semibold h-12 px-6 rounded-lg w-full text-center py-4 flex-1 items-center justify-center dark:bg-sky-500 dark:highlight-white/20 dark:hover:bg-sky-400")

  end

  def continue_or_try_again(conn, _status) do
     form_for(conn, ~p"/hangman", [ as: "make_move", method: :put], fn f ->
       [text_input(f, :guess, class: "form-control flex-1 focus:ring-2 focus:ring-blue-500 focus:outline-none appearance-none w-full text-sm leading-6 text-slate-900 placeholder-slate-400 rounded-md py-2 pl-10 ring-1 ring-slate-200 shadow-sm", placeholder: "Make a guess"),
       submit("Make a guess", class: "mt-6 sm:mt-10 bg-slate-900 hover:bg-slate-700 focus:outline-none focus:ring-2 focus:ring-slate-400 focus:ring-offset-2 focus:ring-offset-slate-50 text-white font-semibold h-12 px-6 rounded-lg w-full text-center flex-1 items-center justify-center dark:bg-sky-500 dark:highlight-white/20 dark:hover:bg-sky-400")]
     end)
  end 
end
