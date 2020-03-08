defmodule ElixirCowboyExample.Application do
  @moduledoc false

  use Application
  import Supervisor.Spec

  def start(_type, _args) do
    children = [
      worker(Mongo, [[name: :mongo, database: "test", pool_size: 3]]),
      worker(ElixirCowboyExample.CowboyServer, [])
    ]

    opts = [strategy: :one_for_one, name: ElixirCowboyExample.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
