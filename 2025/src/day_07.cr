require "../helpers"

class Day07
  def self.parse_board(input : String)
    board = Set(Point).new
    start_pos = Point.new(0, 0)

    input.lines.each_with_index do |line, y|
      line.chars.each_with_index do |char, x|
        point = Point.new(x, y)
        board << point if char == '^'

        if char == 'S'
          start_pos = point
        end
      end
    end

    return board, [start_pos]
  end

  def self.part_1(input : String) : Int32
    board, to_visit = parse_board(input)
    max_y = input.lines.size

    visited = Set(Point).new
    board_visits = Set(Point).new

    while to_visit.size > 0
      cell, *to_visit = to_visit

      next if visited.includes?(cell) || cell.y > max_y
      visited.add(cell)

      down = cell.down

      if board.includes?(down)
        board_visits.add(down)
        to_visit << down.left
        to_visit << down.right
      else
        to_visit << down
      end
    end

    board_visits.size
  end

  def self.count_splits(board : Set(Point), cell : Point, cache = Hash(Point, Int64).new) : Int64
    max_y = board.map { |d| d.y }.max || 0
    return 1_i64 if cell.y > max_y

    if cache.has_key?(cell)
      return cache[cell]
    end
    down = cell.down

    unless board.includes?(down)
      result = count_splits(board, down, cache)
      cache[cell] = result
      return result
    end

    left_splits = count_splits(board, down.left, cache)
    right_splits = count_splits(board, down.right, cache)

    result = left_splits + right_splits

    cache[cell] = result
  end

  def self.part_2(input : String) : Int64
    board, to_visit = parse_board(input)
    max_y = input.lines.size
    start_pos = to_visit[0]
    count_splits(board, start_pos)
  end
end
