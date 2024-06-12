defmodule AdventOfCode2018.Day_2 do
  @doc """
  ## Examples
      iex> AdventOfCode2018.Day_2.count_chars("hello")
      [1, 2]

      iex> AdventOfCode2018.Day_2.count_chars("Hi")
      [1]

      iex> AdventOfCode2018.Day_2.count_chars("spooooooky")
      [1, 6]
  """
  def count_chars(word) when is_binary(word) do
    word |>
      String.to_charlist() |>
      Enum.frequencies() |>
      Map.values() |>
      Enum.uniq()
  end

  @doc """
  ## Examples
      iex> AdventOfCode2018.Day_2.part_1([ "abcdef", "bababc", "abbcde", "abcccd", "aabcdd", "abcdee", "ababab" ])
      12

  """
  def part_1(list \\ AdventOfCode2018.Input.read_list(2)) do
    twos = Enum.count(list, &(2 in count_chars(&1)))
    threes = Enum.count(list, &(3 in count_chars(&1)))

    twos * threes
  end

  @doc """

  ## Examples
  iex> AdventOfCode2018.Day_2.are_prototypes("abcde", "abcdd")
  true

  iex> AdventOfCode2018.Day_2.are_prototypes("abcde", "abcde")
  false

  iex> AdventOfCode2018.Day_2.are_prototypes("edcba", "abcde")
  false
  """
  def are_prototypes(str_a, str_b) do
    differences(
      String.to_charlist(str_a),
      String.to_charlist(str_b)
    ) == 1
  end

  defp diff(a, b) when a == b, do: 0
  defp diff(_, _), do: 1

  @doc """
  ## Examples

  iex> AdventOfCode2018.Day_2.differences(["a", "b"], ["a", "c"])
  1

  iex> AdventOfCode2018.Day_2.differences(["a", "b"], ["a", "b"])
  0

  iex> AdventOfCode2018.Day_2.differences(["b", "a"], ["a", "b"])
  2
  """
  def differences(a, b, count \\ 0)
  def differences([], [], count), do: count
  def differences([hd_a | tail_a], [hd_b | tail_b], count), do: differences(tail_a, tail_b, count + diff(hd_a, hd_b))

  defp common_chars(a, b) do
    Stream.zip(
      String.to_charlist(a),
      String.to_charlist(b)
    ) |>
    Stream.filter(fn {a, b} -> a == b end) |>
    Enum.map(fn {a, _} -> a end)
  end

  def part_2(list \\ AdventOfCode2018.Input.read_list(2)) do
    [a, b] = Enum.filter(list, fn a ->
      Enum.any?(list -- [a], fn b ->
        are_prototypes(a, b)
      end)
    end)

    common_chars(a, b)
  end
end
