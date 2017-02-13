defmodule Pipeline do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Pipeline.Queue, [:pipeline_queue]),
      worker(Pipeline.Consumer, [:consumer, :pipeline_queue]),
    ]

    opts = [strategy: :one_for_one, name: Pipeline.Supervisor]
    Supervisor.start_link(children, opts)
  end
  
  def enqueue event do
    GenServer.cast(:pipeline_queue, {:notify, {event, System.system_time(:seconds)}})
  end
end
