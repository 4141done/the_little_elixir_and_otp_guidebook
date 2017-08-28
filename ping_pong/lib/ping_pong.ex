defmodule PingPong do
  def play do
    coordinator_pid =
      spawn(PingPong.Coordinator, :loop, [
        %{
          ponger_pid: spawn(PingPong.Ponger, :loop, []),
          pinger_pid: spawn(PingPong.Pinger, :loop, [])
        }
      ])

    send(coordinator_pid, { :ok, :ping })

    coordinator_pid
  end

  def stop_game(coordinator_pid) do
    send(coordinator_pid, :exit)
  end
end
