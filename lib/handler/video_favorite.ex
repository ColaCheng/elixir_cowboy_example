defmodule ElixirCowboyExample.Handler.VideoFavorite do
  alias ElixirCowboyExample.Handler.Utils, as: HUtils
  alias ElixirCowboyExample.Utils
  alias ElixirCowboyExample.Context.VideoFavorite

  def init(req_in, opts) do
    request = %{
      method: :cowboy_req.method(req_in),
      user_id: :cowboy_req.binding(:user_id, req_in),
      video_id: :cowboy_req.binding(:video_id, req_in, nil),
      query: :cowboy_req.parse_qs(req_in),
      data: %{}
    }

    {result, req_done} =
      case :cowboy_req.has_body(req_in) do
        true ->
          {:ok, body, req_out} = HUtils.read_body(req_in, <<>>)

          case HUtils.decode_body(body, :json) do
            {:ok, data} ->
              {process_request(Map.put(request, :data, data)), req_out}

            :error ->
              {:invalid_json, req_out}
          end

        false ->
          {process_request(request), req_in}
      end

    case make_response(result) do
      {code, response} ->
        {:ok,
         :cowboy_req.reply(
           code,
           %{<<"content-type">> => <<"application/json">>},
           :jiffy.encode(response),
           req_done
         ), opts}

      code ->
        {:ok, :cowboy_req.reply(code, req_done), opts}
    end
  end

  defp process_request(%{
         method: method,
         user_id: user_id,
         video_id: video_id,
         query: query,
         data: data
       }) do
    case method do
      "GET" ->
        get_video_favorite(user_id, query)

      "POST" ->
        add_video_favorite(user_id, data)

      "DELETE" ->
        delete_video_favorite(user_id, video_id)

      _ ->
        :method_not_allowed
    end
  end

  defp get_video_favorite(user_id, query) do
    with cursor when cursor == nil or byte_size(cursor) == 24 <-
           :proplists.get_value("cursor", query, nil),
         sort_s when sort_s in ["asc", "des"] <- :proplists.get_value("sort", query, "des"),
         limit_s <- :proplists.get_value("limit", query, "50"),
         {:ok, limit} <- Utils.string_to_integer(limit_s) do
      sort = (sort_s == "asc" && 1) || -1
      VideoFavorite.get(user_id, %{cursor: cursor, sort: sort, limit: limit})
    else
      _ -> :invalid_property
    end
  end

  defp add_video_favorite(user_id, data) do
    case data do
      %{"video_id" => video_id} when is_binary(video_id) ->
        VideoFavorite.add(user_id, video_id)

      _ ->
        :invalid_property
    end
  end

  defp delete_video_favorite(user_id, video_id) do
    case video_id do
      nil ->
        :method_not_allowed

      _ ->
        VideoFavorite.delete(user_id, video_id)
    end
  end

  defp make_response({:ok, result}), do: {200, result}
  defp make_response(:created), do: 201
  defp make_response(:deleted), do: 205
  defp make_response(:invalid_json), do: {400, %{message: "Invalid JSON."}}

  defp make_response(:invalid_property),
    do: {400, %{message: "Invalid property or property format."}}

  defp make_response(:notfound), do: {404, %{message: "Not found."}}
  defp make_response(:method_not_allowed), do: {405, %{message: "Method not allowed."}}

  defp make_response(:duplicate_video),
    do: {409, %{message: "Entry with the same video already exists."}}

  defp make_response(:error), do: {500, %{message: "Internal server error."}}
end
