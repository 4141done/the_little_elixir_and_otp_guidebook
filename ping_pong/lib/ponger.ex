defmodule PingPong.Ponger do
  def loop() do
    receive do
      {:ping, caller} ->
        send(caller, {:ok, :pong})
        loop()

      :exit ->
        IO.puts("Shutting down the ponger")

      _ ->
        loop()
    end
  end
end