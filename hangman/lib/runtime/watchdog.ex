defmodule Hangman.Runtime.Watchdog do
  def start(expiry_time) do
    spawn_link(fn -> watcher expiry_time end )
  end 

  def alive(watcher) do
    send(watcher, :alive)
  end

  defp watcher(expiry_time) do
    receive do 
      :alive ->
        watcher expiry_time

      after expiry_time ->
        Process.exit(self(), { :shutdown, :watchdog_triggered })
    end  
  end 
end 