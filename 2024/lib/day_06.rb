require_relative "./helpers"

class Day06
  def self.turn(dir)
    case dir
    when [-1, 0] then [0, 1]
    when [0, 1] then [1, 0]
    when [1, 0] then [0, -1]
    when [0, -1] then [-1, 0]
    end
  end

  def self.part_1(input)
    grid = input.strip.split("\n").map(&:chars)

    visited, reason = walk(grid)

    return visited.count
  end

  def self.walk(grid)
    guard_pos = [0, 0]
    guard_dir = [-1, 0]

    visited = {}
    states = {}
    steps = 0

    grid.each_with_index do |row, i|
      row.each_with_index do |col, j|
        if col == "^"
          guard_pos = [i, j]
          visited[[i, j]] = true
          # states[[i, j] + guard_dir] = true
        end
      end
    end

    while true
      new_pos = AdventOfCodeHelpers.add_number_arrays(guard_pos, guard_dir)

      row, col = new_pos

      if row < 0 || col < 0 || row >= grid.length || col >= grid[0].length
        return visited.keys, "LEFT"
      end

      if grid[new_pos[0]][new_pos[1]] == "#"
        guard_dir = turn(guard_dir)
        next
      end

      guard_pos = new_pos
      visited[guard_pos] = true

      if states[guard_pos + guard_dir]
        return visited.keys, "LOOP"
      end

      states[guard_pos + guard_dir] = true
    end
  end

  def self.part_2(input)
    grid = input.strip.split("\n").map(&:chars)

    positions, _ = walk(grid)

    positions.map.with_index do |pos, index|
      i, j = pos

      next if grid[i][j] == "^"

      grid[i][j] = "#"

      _, reason = walk(grid)

      grid[i][j] = "."

      reason
    end.count("LOOP")
  end
end
