defmodule PingPong.Pinger do
  def loop() do
    receive do
      {:pong, caller} ->
        send(caller, {:ok, :ping})
        loop()

      :exit ->
        IO.puts("Shutting down the pinger")

      _ ->
        loop()
    end
  end
end