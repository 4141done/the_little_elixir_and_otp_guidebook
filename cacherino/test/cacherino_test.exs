defmodule CacherinoTest do
  use ExUnit.Case
  doctest Cacherino

  test "greets the world" do
    assert Cacherino.hello() == :world
  end
end
