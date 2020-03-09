import Config

config :logger,
  level: :info

config :elixir_cowboy_example,
  mongodb_url: System.get_env("MONGODB_URL") || "mongodb://localhost:27017/test"

import_config "#{Mix.env()}.exs"
