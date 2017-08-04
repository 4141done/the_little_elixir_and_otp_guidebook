defmodule MyList do
  # Order of these functions matter.  If we swapped the first and the last definition the base case would never get matched
  def flatten([]), do: []

  def flatten([head | tail]) do
    flatten(head) ++ flatten(tail)
  end

  def flatten(head), do: [ head ]
end