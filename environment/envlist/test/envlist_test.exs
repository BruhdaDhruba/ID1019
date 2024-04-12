defmodule EnvlistTest do
  use ExUnit.Case
  doctest Envlist

  test "greets the world" do
    assert Envlist.hello() == :world
  end
end
