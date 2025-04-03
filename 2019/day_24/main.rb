require 'set'
input = File.readlines("./input.txt", chomp: true).map(&:chars)

def str_board(i)
  str = ""
  i.each do |row|
    str << row.join("")
    str << "\n"
  end

  str
end

def neighbors(x, y, max = 4)
  [
    [x - 1, y],
    [x + 1, y],
    [x, y - 1],
    [x, y + 1],
  ].filter{|x, y| x >= 0 && x <= max && y >= 0 && y <= max}
end

@bug = "#"
@empty = "."

def next_gen(board)
  new_board = board.map(&:dup)

  new_board.each_with_index do |row, i|
    row.each_with_index do |ch, j|
      n = neighbors(i, j).map{|x, y| board[x][y]}.tally

      if ch == @empty
        new_board[i][j] = [1, 2].include?(n[@bug]) ? @bug : @empty
      else
        new_board[i][j] = n[@bug] == 1 ? @bug : @empty
      end
    end
  end

  new_board
end

boards = Set.new
boards << str_board(input)

def bio_diversity(board)
  power = 0
  sum = 0

  board.each do |row|
    row.each do |ch|
      if ch == @bug
        sum += (2 ** power)
      end
      power += 1
    end
  end

  sum
end

# Part 1 solution
def part1(input)
  current_board = input.map(&:dup)
  boards = Set.new
  boards << str_board(current_board)

  loop do
    current_board = next_gen(current_board)
    str = str_board(current_board)

    break if boards.include? str

    boards << str
  end

  bio_diversity(current_board)
end

puts "Part 1: #{part1(input)}"

# Part 2 solution
def recursive_neighbors(x, y, level)
  neighbors = []
  
  if x == 0
    neighbors << [1, 2, level - 1]
  elsif x == 3 && y == 2
    (0..4).each do |inner_y|
      neighbors << [4, inner_y, level + 1]
    end
  else
    neighbors << [x - 1, y, level]
  end

  if x == 4
    neighbors << [3, 2, level - 1]
  elsif x == 1 && y == 2
    (0..4).each do |inner_y|
      neighbors << [0, inner_y, level + 1]
    end
  else
    neighbors << [x + 1, y, level]
  end

  if y == 0
    neighbors << [2, 1, level - 1]
  elsif x == 2 && y == 3
    (0..4).each do |inner_x|
      neighbors << [inner_x, 4, level + 1]
    end
  else
    neighbors << [x, y - 1, level]
  end

  if y == 4
    neighbors << [2, 3, level - 1]
  elsif x == 2 && y == 1
    (0..4).each do |inner_x|
      neighbors << [inner_x, 0, level + 1]
    end
  else
    neighbors << [x, y + 1, level]
  end

  neighbors
end

def count_bugs(grids)
  grids.values.sum do |grid|
    grid.sum { |row| row.count(@bug) }
  end
end

def next_gen_recursive(grids)
  min_level = grids.keys.min - 1
  max_level = grids.keys.max + 1
  
  new_grids = {}
  
  empty_grid = Array.new(5) { Array.new(5, @empty) }
  
  (min_level..max_level).each do |level|
    new_grids[level] = Array.new(5) { Array.new(5, @empty) }
    
    current_grid = grids[level] || empty_grid
    
    5.times do |i|
      5.times do |j|
        next if i == 2 && j == 2 # Skip the center
        
        bug_count = 0
        recursive_neighbors(i, j, level).each do |nx, ny, nl|
          # Skip if outside grid bounds or center cell
          next if nx < 0 || nx > 4 || ny < 0 || ny > 4
          next if nx == 2 && ny == 2
          
          neighbor_grid = grids[nl] || empty_grid
          bug_count += 1 if neighbor_grid[nx][ny] == @bug
        end
        
        if current_grid[i][j] == @bug
          new_grids[level][i][j] = (bug_count == 1) ? @bug : @empty
        else
          new_grids[level][i][j] = (bug_count == 1 || bug_count == 2) ? @bug : @empty
        end
      end
    end
  end
  
  new_grids.delete(min_level) if new_grids[min_level].flatten.all? { |cell| cell == @empty }
  new_grids.delete(max_level) if new_grids[max_level].flatten.all? { |cell| cell == @empty }
  
  new_grids
end

def part2(input, minutes = 200)
  grids = { 0 => input.map(&:dup) }
  
  minutes.times do |i|
    grids = next_gen_recursive(grids)
  end
  
  count_bugs(grids)
end

puts "Part 2: #{part2(input)}"
