require_relative '../intcode.rb'

i = Intcode.new(File.read('./input.txt'))

until i.halted
  i.step
end

str = ""

i.outputs.each do |v|
  str << v.chr
end

arr = str.strip.lines.map(&:strip).map(&:chars)

intersections = []

arr.each_with_index do |row, y|
  next if y == 0 || (y + 1) == arr.length
  
  row.each_with_index do |ch, x|
    next if x == 0 || (x + 1) == row.length || ch != '#'
    next if arr[y-1][x] != '#'
    next if arr[y+1][x] != '#'
    next if arr[y][x-1] != '#'
    next if arr[y][x+1] != '#'
    
    intersections << x * y
  end
end

p intersections.sum

i.reset
i.program[0] = 2

a = "A,B,A,C,A,B,C,A,B,C
R,12,R,4,R,10,R,12
R,6,L,8,R,10
L,8,R,4,R,4,R,6
n
".chars.map(&:ord)

i.inputs = a

i.step until i.halted

p i.outputs[-1]

"
Notes from manual solve:

Main: A,B,A,C,A,B,C,A,B,C
A = R,12,R,4,R,10,R,12
B = R,6,L,8,R,10
C = L,8,R,4,R,4,R,6
Continuous Video Feed = n

Original path
R,12,R,4,R,10,R,12,R,6,L,8,R,10,R,12,R,4,R,10,R,12,
L,8,R,4,R,4,R,6,R,12,R,4,R,10,R,12,R,6,L,8,R,10,L,8,
R,4,R,4,R,6,R,12,R,4,R,10,R,12,R,6,L,8,R,10,L,8,R,4,
R,4,R,6
"
