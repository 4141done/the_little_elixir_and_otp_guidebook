defmodule GenMetex.Worker do
  use GenServer

  # Using a name like this creates a singleton worker.  There are probably
  # a lot of cases where this is not desirable
  @name MW
  ## Client API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts ++ [name: MW])
  end

  def get_temperature(location) do
    GenServer.call(@name, {:location, location})
  end

  def get_stats do
    GenServer.call(@name, :get_stats)
  end

  def reset_stats do
    GenServer.cast(@name, :reset_stats)
  end

  def stop do
    GenServer.cast(@name, :stop)
  end
  ## Server callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:location, location}, _from, stats) do
    case temperature_of(location) do
      {:ok, temp} ->
        new_stats = update_stats(stats, location)
        {:reply, "#{temp}℃", new_stats}

      _ ->
        {:reply, :error, stats}
    end
  end

  def handle_call(:get_stats, _from, stats) do
    {:reply, stats, stats}
  end

  # Question: how does returning the empty state here reset the state?
  # Where is that being kept track of on the client side?

  # Answer: this works just like the loop functions I did before genservers.
  # So this callback will be invoked somewhere and the ```state``` parameter
  # (in this case called "stats". It is state by its passing position)
  # will be passed back in to "loop" as the new current value.
  # Thereful we just need to understand that the new state as stored by
  # the process is what we pass in the "state" position for any handlers
  def handle_cast(:reset_stats, _stats) do
    {:noreply, %{}}
  end

  def handle_cast(:stop, stats) do
    {:stop, :normal, stats}
  end

  def handle_info(msg, stats) do
    IO.puts "received #{inspect msg}"
    {:noreply, stats}
  end

  def terminate(reason, stats) do
    # Do any necessary cleanup here, like persisting data
    IO.puts "Server terminated because of #{inspect reason}"
    inspect stats
    :ok
  end

  ## Helper functions
  defp temperature_of(location) do
    url_for(location) |> HTTPoison.get |> parse_response
  end

  defp url_for(location) do
    "http://api.openweathermap.org/data/2.5/weather?q=#{location}&APPID=#{apikey()}"
  end

  defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body |> JSON.decode! |> compute_temperature
  end

  defp parse_response(_) do
    :error
  end

  defp compute_temperature(json) do
    try do
      temp = (json["main"]["temp"] - 273.15) |> Float.round(1)
      {:ok, temp}

    rescue
      _ -> :error
    end
  end

  def apikey do
    "9f53f7c1ca80fe54ec789d5e8ea747c8"
  end

  defp update_stats(old_stats, location) do
    case Map.has_key?(old_stats, location) do
      true ->
        Map.update!(old_stats, location, &(&1 + 1))
      false ->
        Map.put(old_stats, location, 1)
    end
  end
end