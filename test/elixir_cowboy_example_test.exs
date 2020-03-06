defmodule ElixirCowboyExampleTest do
  use ExUnit.Case
  doctest ElixirCowboyExample

  test "greets the world" do
    assert ElixirCowboyExample.hello() == :world
  end
end
