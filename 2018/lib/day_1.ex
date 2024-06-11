defmodule AdventOfCode2018 do
  defmodule Day_1 do
    @doc """
    ## Examples
        iex> AdventOfCode2018.Day_1.part_1([ "-1", "-2", "-3" ])
        -6
    """
    def part_1(list \\ AdventOfCode2018.Input.read_list(1)) do
      inputs = for x <- list, do: elem(Integer.parse(x), 0)
      Enum.sum(inputs)
    end

    @doc """
    ## Examples
      iex> AdventOfCode2018.Day_1.part_2(["+3", "+3", "+4", "-2", "-4"])
      10
    """
    def part_2(list \\ AdventOfCode2018.Input.read_list(1)) do
      inputs = for x <- list, do: elem(Integer.parse(x), 0)
      find_repeating_freq(inputs)
    end

    def find_repeating_freq(list, freq \\ 0, map \\ %{}) do
      if Map.has_key?(map, freq) do
        freq
      else
        [head | tail] = list

        find_repeating_freq(tail ++ [head], freq + head, Map.put_new(map, freq, 1))
      end
    end
  end

  defmodule Input do

    @doc """

    ## Examples

      iex> length(AdventOfCode2018.Input.read_list(1))
      968
    """
    def read_list(day) do
      String.split(File.read!("inputs/day_#{day}.txt"), "\n", trim: true)
    end
  end
end
