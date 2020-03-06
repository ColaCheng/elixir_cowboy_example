defmodule ElixirCowboyExample.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    dispatch =
      :cowboy_router.compile([
        {
          :_,
          [
            {"/", ElixirCowboyExample.Handler.Example, []}
          ]
        }
      ])

    {:ok, _} = :cowboy.start_clear(:http, [port: 8080], %{env: %{dispatch: dispatch}})

    children = []

    opts = [strategy: :one_for_one, name: ElixirCowboyExample.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
