defmodule MathOps do
  def sum([]), do: 0

  def sum([first, second | tail]) do
    sum([first + second] ++ tail)
  end

  def sum([first]), do: first
end