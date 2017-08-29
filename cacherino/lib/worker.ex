defmodule Cacherino.Worker do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    {:ok, %{}}
  end

  # Client API
  def write(pid, key, value) do
    GenServer.call(pid, {:write, {key, value}})
  end

  def read(pid, key) do
    GenServer.call(pid, {:read, key})
  end

  def delete(pid, key) do
    GenServer.call(pid, {:delete, key})
  end

  def exist?(pid, key) do
    GenServer.call(pid, {:exists, key})
  end

  def clear(pid) do
    GenServer.cast(pid, :clear)
  end
  
  # Server API
  def handle_call({:write, {key, value}}, _from, cache) do
    new_map = Map.put(cache, key, value)
    {:reply, new_map, new_map}
  end

  def handle_call({:read, key}, _from, cache) do
    {:reply, Map.get(cache, key), cache}
  end

  def handle_call({:delete, key}, _from, cache) do
    new_cache = Map.delete(cache, key)
    {:reply, new_cache, new_cache}
  end

  def handle_call({:exists, key}, _from, cache) do
    {:reply, Map.has_key?(cache, key), cache}
  end


  def handle_cast(:clear, _cache) do
    {:noreply, %{}}
  end
  # Helper methods

end