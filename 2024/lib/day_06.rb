require_relative "./helpers"

class Day06
  def self.parse(input)
    grid = input.strip.split("\n").map(&:chars)
    start = []

    grid.each_with_index do |row, i|
      row.each_with_index do |col, j|
        if col == "^"
          start = [i, j]
        end
      end
    end

    return grid, start
  end
  def self.turn(dir)
    case dir
    when [-1, 0] then [0, 1]
    when [0, 1] then [1, 0]
    when [1, 0] then [0, -1]
    when [0, -1] then [-1, 0]
    end
  end

  def self.part_1(input)
    grid, start = parse(input)

    visited, reason = walk(grid, start)

    return visited.uniq.count
  end

  def self.walk(grid, start)
    guard_row = start[0]
    guard_col = start[1]
    guard_dir = [-1, 0]

    visited = []
    states = {}

    row_length = grid.length
    col_length = grid[0].length

    while true
      row = guard_row + guard_dir[0]
      col = guard_col + guard_dir[1]

      if row < 0 || col < 0 || row >= row_length || col >= col_length
        return visited, "LEFT"
      end

      if grid[row][col] == "#"
        guard_dir = turn(guard_dir)
        next
      end

      guard_row = row
      guard_col = col
      visited.push "#{row},#{col}"

      key = row * 100000 + col * 100 + guard_dir[0] * 10 + guard_dir[1]

      # state_key = "#{row},#{col},#{guard_dir[0]},#{guard_dir[1]}"
      if states[key]
        return visited, "LOOP"
      end

      states[key] = true
    end
  end

  def self.part_2(input)
    grid, start = parse(input)

    positions, _ = walk(grid, start)
    positions = positions.uniq.map { |pos| pos.split(",").map(&:to_i) }

    positions.count do |pos|
      i, j = pos

      next if i == start[0] && j == start[1]

      grid[i][j] = "#"

      _, reason = walk(grid, start)

      grid[i][j] = "."

      reason == "LOOP"
    end
  end
end
