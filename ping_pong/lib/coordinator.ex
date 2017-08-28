defmodule PingPong.Coordinator do
  def loop(%{pinger_pid: pinger_pid, ponger_pid: ponger_pid}) do
    receive do
      {:ok, :ping} ->
        IO.puts "Ping!"
        send(ponger_pid, {:ping, self()})
        loop(%{pinger_pid: pinger_pid, ponger_pid: ponger_pid})

      {:ok, :pong} ->
        IO.puts "Pong!"
        send(pinger_pid, {:pong, self()})
        loop(%{pinger_pid: pinger_pid, ponger_pid: ponger_pid})

      :exit ->
        IO.puts "Coordinator shutting down"
        send(pinger_pid, :exit)
        send(ponger_pid, :exit)

      _ ->
        loop(%{pinger_pid: pinger_pid, ponger_pid: ponger_pid})
    end
  end

end