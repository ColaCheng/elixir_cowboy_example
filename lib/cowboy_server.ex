defmodule ElixirCowboyExample.CowboyServer do
  use GenServer

  @mongo_server :mongo
  @video_favorite_coll "videoFavorites"

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_) do
    init_indexes()

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
  end

  defp init_indexes() do
    :ok =
      Mongo.create_indexes(
        @mongo_server,
        @video_favorite_coll,
        [[{"key", [{"user_id", 1}, {"video_id", 1}]}, {"name", "user_id.video_id"}]],
        [{"unique", 1}]
      )
  end
end
