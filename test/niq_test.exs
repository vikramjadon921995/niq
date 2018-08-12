defmodule NiqTest do
  use ExUnit.Case
  doctest Niq

  test "greets the world" do
    assert Niq.hello() == :world
  end
end
