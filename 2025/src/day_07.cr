alias Point = Tuple(Int32, Int32)

class Day07
  def self.parse_board(input : String)
    board = Set(Point).new
    start_pos = {0, 0}
    
    input.lines.each_with_index do |line, y|
      line.chars.each_with_index do |char, x|
        board<< {x, y} if char == '^'
        
        if char == 'S'
          start_pos = {x, y}
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
      
      next if visited.includes?(cell) || cell[1] > max_y
      visited.add(cell)
      
      x, y = cell
      down = board.includes?({x, y + 1})
      
      if down
        board_visits.add({x, y + 1})
        to_visit << {x - 1, y + 1}
        to_visit << {x + 1, y + 1}
      else
        to_visit << {x, y + 1}
      end
    end
    
    board_visits.size
  end
  
  def self.count_splits(board : Set(Point), cell : Point, cache = Hash(Point, Int64).new) : Int64
    x, y = cell
    max_y = board.map { |d| d[1]}.max || 0
    return 1_i64 if y > max_y

    if cache.keys.includes?(cell)
      return cache[cell]
    end
    down = board.includes?({x, y + 1})

    unless down
      result = count_splits(board, {x, y + 1}, cache)
      cache[cell] = result
      return result
    end
    
    left_splits = count_splits(board, {x - 1, y + 1}, cache)
    right_splits = count_splits(board, {x + 1, y + 1}, cache)

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
