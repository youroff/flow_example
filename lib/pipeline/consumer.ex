defmodule Pipeline.Consumer  do

  def start_link(name, producer) do
    window = Flow.Window.session(30, :second, & elem(&1, 1) * 1000)
    key = & elem(&1, 0)
    Flow.from_stage(producer, key: key, window: window, stages: 1)
    |> Flow.reduce(fn -> [] end, &[&1 | &2])
    |> Flow.each_state(&IO.inspect/1)
    |> Flow.start_link(name: name)
  end
end
