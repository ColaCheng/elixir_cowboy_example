defmodule ElixirCowboyExample.Context.VideoFavorite do
  @mongo_server :mongo
  @collection "videoFavorites"

  def add(user_id, video_id) do
    case Mongo.insert_one(@mongo_server, @collection, %{user_id: user_id, video_id: video_id}) do
      {:ok, _} ->
        :created

      {:error, %Mongo.WriteError{write_errors: [%{"code" => 11000}]}} ->
        :duplicate_video

      {:error, _} ->
        :error
    end
  end

  def get(user_id, %{cursor: cursor, sort: sort, limit: limit}) do
    base_filter = %{user_id: user_id}

    filter =
      case cursor do
        nil -> base_filter
        _ -> Map.put(base_filter, :_id, %{"$gt" => BSON.ObjectId.decode!(cursor)})
      end

    try do
      {next_cursor, videos} =
        Mongo.find(@mongo_server, @collection, filter, sort: %{_id: sort}, limit: limit)
        |> Enum.reduce({nil, []}, fn %{"_id" => bson_id, "video_id" => video_id}, {_, acc} ->
          id = BSON.ObjectId.encode!(bson_id)
          {id, [%{id: id, video_id: video_id} | acc]}
        end)

      {:ok, %{cursor: next_cursor, videos: Enum.reverse(videos)}}
    catch
      _ -> :error
    end
  end

  def delete(user_id, video_id) do
    case Mongo.delete_one(@mongo_server, @collection, %{user_id: user_id, video_id: video_id}) do
      {:ok, %Mongo.DeleteResult{deleted_count: 1}} -> :deleted
      {:ok, %Mongo.DeleteResult{deleted_count: 0}} -> :notfound
      {:error, _} -> :error
    end
  end
end
