defmodule FileFiler do
  def filter(directory, file_extension, search) do
    directory
    |> Path.join("**/*.#{file_extension}")
    |> Path.wildcard
    |> Enum.filter(fn fname ->
        String.contains?(Path.basename(fname), search)
      end)
  end
end