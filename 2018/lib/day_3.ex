defmodule AdventOfCode2018.Day_3 do
  defmodule Plot do
    defstruct [:id, :x, :y, :dx, :dy]

    def parse(line) do
      [id, x,y,dx,dy] =
        Regex.run(~r/#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/, line) |>
        tl() |>
        Enum.map(&(elem(Integer.parse(&1), 0)))

      %Plot{id: id, x: x, y: y, dx: dx, dy: dy}
    end

    def overlaps(a, b) do
      x_overlaps = line_overlaps(a.x, b.x, b.x + b.dx) or line_overlaps(b.x, a.x, a.x + a.dx)
      y_overlaps = line_overlaps(a.y, b.y, b.y + b.dy) or line_overlaps(b.y, a.y, a.y + a.dy)

      x_overlaps and y_overlaps
    end

    defp line_overlaps(val, min, max) do
      val >= min and val <= max
    end
  end

  def part_1(file \\AdventOfCode2018.Input.read_list(3)) do
    file |>
    Stream.flat_map(fn plot ->
      plot = Plot.parse(plot)
      max_x = plot.x + plot.dx - 1
      max_y = plot.y + plot.dy - 1
      for x <- plot.x..max_x, y <- plot.y..max_y, do: {x, y}
    end) |>
    Enum.frequencies() |>
    Map.values() |>
    Enum.filter(&(&1 > 1))
    |> length()
  end

  def part_2(file \\ AdventOfCode2018.Input.read_list(3)) do
    plots = file |> Enum.map(&(Plot.parse &1))

    Enum.filter(plots, fn plot ->
      plots = plots -- [plot]

      not Enum.any?(plots, &(Plot.overlaps(plot, &1)))
    end)
  end
end
