defmodule ElixirCowboyExample.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_cowboy_example,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      applications: [
        :cowboy,
        :mongodb_driver
      ],
      extra_applications: [:logger],
      mod: {ElixirCowboyExample.Application, []}
    ]
  end

  defp deps do
    [
      {:cowboy, "~> 2.7.0"},
      {:jiffy, "~> 1.0"},
      {:mongodb_driver, "~> 0.6"}
    ]
  end
end
