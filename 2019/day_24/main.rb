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

loop do
  input = next_gen(input)
  str = str_board(input)

  break if boards.include? str

  boards << str
end

p bio_diversity(input)
