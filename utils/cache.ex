defmodule Cache do 

  def run(body, initial_state) do 
    { :ok, pid } = Agent.start_link(fn -> initial_state end)
    result = body.(pid)
    Agent.stop(pid)
    result
  end

  def lookup(cache, key, if_not_found) do
    Agent.get(cache, fn map -> map[key] end)
    |> complete_if_not_found(cache, key, if_not_found)
  end 

  defp complete_if_not_found(nil, cache, key, if_not_found) do
    if_not_found.()
    |> set(cache, key)
  end 

  defp complete_if_not_found(value, _cache, _key, _if_not_found) do
    value
  end
  
  defp set(value, cache, key) do 
    Agent.get_and_update(cache, fn map -> { value, Map.put(map, key, value)} end)
  end 
end 