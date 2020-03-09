defmodule ElixirCowboyExample.Application do
  @moduledoc false

  use Application
  import Supervisor.Spec

  def start(_type, _args) do
    mongodb_url = Application.fetch_env!(:elixir_cowboy_example, :mongodb_url)

    children = [
      worker(Mongo, [[name: :mongo, url: mongodb_url]]),
      worker(ElixirCowboyExample.CowboyServer, [])
    ]

    opts = [strategy: :one_for_one, name: ElixirCowboyExample.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
