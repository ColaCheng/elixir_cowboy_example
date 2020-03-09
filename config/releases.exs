import Config

config :elixir_cowboy_example,
  mongodb_url: System.fetch_env!("MONGODB_URL")
