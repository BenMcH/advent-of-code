require 'set'
require_relative '../intcode.rb'

input = File.read("./input.txt")

computer = Intcode.new(input)

board = Hash.new(0)

dir = [-1, 0]
loc = [0, 0]

def turn_left(dir)
  case dir
  when [-1, 0]
    [0, -1]
  when [0, -1]
    [1, 0]
  when [1,0]
    [0, 1]
  when [0, 1]
    [-1, 0]
  end
end

def turn_right(dir)
  turn_left turn_left turn_left dir
end

input_written = false
written = Set.new
count = 0
until computer.halted

  unless input_written
    inst = board[loc]
    computer.inputs << inst
    input_written = true
  end

  if computer.outputs.length == 2
    written << loc.dup
    count += 1
    board[loc] = computer.outputs.shift
    dir = computer.outputs.shift == 0 ? turn_left(dir) : turn_right(dir)
    loc = [loc[0] + dir[0], loc[1] + dir[1]]

    input_written = false
  else
    computer.step
  end
end

p written.length
computer.reset

board = Hash.new(0)
loc = [0, 0]
board[loc] = 1

input_written = false
written = Set.new
until computer.halted

  unless input_written
    inst = board[loc]
    computer.inputs << inst
    input_written = true
  end

  if computer.outputs.length == 2
    written << loc.dup
    count += 1
    board[loc] = computer.outputs.shift
    dir = computer.outputs.shift == 0 ? turn_left(dir) : turn_right(dir)
    loc = [loc[0] + dir[0], loc[1] + dir[1]]

    input_written = false
  else
    computer.step
  end
end

cells = board.keys

min_y, max_y = cells.map(&:first).minmax
min_x, max_x = cells.map(&:last).minmax

p min_y, max_y, min_x, max_x

str = ""
(min_y..max_y).each do |y|
  (min_x..max_x).each do |x|
    if board[[y, x]] == 1
      str << "#"
    else
      str << " "
    end
  end
  str << "\n"
end

puts str
