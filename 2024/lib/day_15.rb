class Day15
  def self.parse(input)
    map, instructions = input.split("\n\n")

    map = map.split("\n").map(&:chars)
    dirs = {
      "^".to_sym => [-1, 0],
      ">".to_sym => [0, 1],
      "v".to_sym => [1, 0],
      "<".to_sym => [0, -1],
    }
    instructions = instructions.chars.map { |c| dirs[c.to_sym] }.filter { |c| c != nil }

    return map, instructions
  end

  def self.move(board, cell, direction)
    y, x = cell

    return true if board[y][x] == "."
    return false if board[y][x] == "#"
    next_spot = [y + direction[0], x + direction[1]]

    if move(board, next_spot, direction)
      c = board[y][x]
      board[next_spot[0]][next_spot[1]] = c
      board[y][x] = "."
      return true
    end
  end

  def self.part_1(input)
    board, instructions = parse input
    robot_x = 0
    robot_y = 0

    board.each_with_index do |row, y|
      row.each_with_index do |col, x|
        if col == "@"
          robot_x, robot_y = x, y
        end
      end
    end

    instructions.each do |instr|
      move(board, [robot_y, robot_x], instr)

      unless board[robot_y][robot_x] == "@"
        robot_y += instr[0]
        robot_x += instr[1]
      end
    end

    locs = 0

    board.each_with_index do |row, y|
      row.each_with_index do |col, x|
        locs += y * 100 + x if col == "O"
      end
    end

    locs
  end

  def self.part_2(input)
    return 0
  end
end
