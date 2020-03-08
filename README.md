# Elixir Cowboy Example

This is a simple example to use [Cowboy](https://ninenines.eu/docs/) and [MongoDB](https://www.mongodb.com/) to build a web API server. Also, show out the basic code structure in my opinions.

## Usage

Make sure you have elixir >= 1.7.0 and docker installed. Run the following commands:

```
$ docker run --name <container_name> -v <your local folder path>:/data/db -p 27017:27017 -d mongo
$ mix deps.get
$ mix deps.compile
$ iex -S mix
```

To test server
```
$ curl -i --request GET http://localhost:8080/
```

## Example included

- A basic endpoint with HTTP GET/POST/PUT/DELETE. See [example.ex](./lib/handler/example.ex).
- A video favorite API with add, get and delete video favorites. See [video_favorite.ex](./lib/handler/video_favorite.ex).
- Accepting a GET request with query params.
- Accepting a request and replying with a JSON object.

### Video Favorite API

#### Add A Video To Favorites
POST /video/:user_id/favorite

example:
```
$ curl -i --request POST http://localhost:8080/video/12345/favorite \
--header 'Content-Type: application/json' \
--data-raw '{
  "video_id": "321"
}'

response:
HTTP/1.1 201 Created
content-length: 0
date: Sun, 08 Mar 2020 13:51:57 GMT
server: Cowboy
```

#### Get User Video Favorites
GET /video/:user_id/favorite?sort=<asc/des>&limit=\<number>&cursor=\<cursor>

example:
```
$ curl -i --request GET http://localhost:8080/video/12345/favorite?sort=des&limit=10

response:
HTTP/1.1 200 OK
content-length: 99
content-type: application/json
date: Sun, 08 Mar 2020 13:54:22 GMT
server: Cowboy

{"videos":[{"video_id":"321","id":"5e64f838dc26e4300a38e638"}],"cursor":"5e64f838dc26e4300a38e638"}
```

#### Delete A Video From Favorites
DELETE /video/:user_id/favorite/:video_id

example:
```
curl -i --request DELETE http://localhost:8080/video/12345/favorite/321

response:
HTTP/1.1 205 Reset Content
content-length: 0
date: Sun, 08 Mar 2020 13:59:03 GMT
server: Cowboy
```