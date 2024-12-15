require_relative "./helpers"

class Day06
  def self.parse(input)
    grid = input.strip.split("\n").map(&:chars)
    start = []

    grid.each_with_index do |row, i|
      row.each_with_index do |col, x|
        if col == "^"
          start = [i, x]
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

  def self.walk(grid, start, part_2 = false, guard_dir = [-1, 0], states = {})
    guard_row = start[0]
    guard_col = start[1]

    visited = []
    count = 0

    row_length = grid.length
    col_length = grid[0].length

    loop do
      row = guard_row + guard_dir[0]
      col = guard_col + guard_dir[1]
      visited_key = row * 1000 + col

      out_of_bounds = row < 0 || col < 0 || row >= row_length || col >= col_length
      return visited, count if out_of_bounds

      if grid[row][col] == "#"
        guard_dir = turn(guard_dir)
        next
      end

      if part_2 and not visited.include? visited_key
        grid[row][col] = "#"
        count += walk(grid, [guard_row, guard_col], false, guard_dir.dup, states.dup).last
        grid[row][col] = "."
      end

      guard_row = row
      guard_col = col
      visited.push visited_key

      key = row * 100000 + col * 100 + guard_dir[0] * 10 + guard_dir[1]
      return visited, 1 if states[key]
      states[key] = true
    end
  end

  def self.part_1(input)
    grid, start = parse(input)

    visited, _ = walk(grid, start)

    return visited.uniq.count
  end

  def self.part_2(input)
    grid, start = parse(input)

    walk(grid, start, true).last
  end
end
