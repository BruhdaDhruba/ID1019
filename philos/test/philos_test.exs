defmodule PhilosTest do
  use ExUnit.Case
  doctest Philos

  test "greets the world" do
    assert Philos.hello() == :world
  end
end
