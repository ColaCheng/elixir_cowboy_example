defmodule ElixirCowboyExample.Application do
  @moduledoc false

  use Application
  import Supervisor.Spec

  def start(_type, _args) do
    dispatch =
      :cowboy_router.compile([
        {
          :_,
          [
            {"/", ElixirCowboyExample.Handler.Example, []},
            {"/video/:user_id/favorite[/:video_id]", ElixirCowboyExample.Handler.VideoFavorite,
             []}
          ]
        }
      ])

    {:ok, _} = :cowboy.start_clear(:http, [port: 8080], %{env: %{dispatch: dispatch}})

    children = [
      worker(Mongo, [[name: :mongo, database: "test", pool_size: 3]])
    ]

    opts = [strategy: :one_for_one, name: ElixirCowboyExample.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
