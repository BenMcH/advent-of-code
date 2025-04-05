input = File.read("./data.txt").strip.chars.map(&:to_i)

ring = {}

input.each_with_index do |i, idx|
  ring[input[idx-1]] = i
end

current_cup = input[0]

def move(ring, current_cup, min, max)
  next_1 = ring[current_cup]
  next_2 = ring[next_1]
  next_3 = ring[next_2]


  nexts = [next_1, next_2, next_3]

  raise "next_3 is bad" if ring[next_3].nil?
  ring[current_cup] = ring[next_3]

  dest = current_cup
  loop do
    dest -= 1

    dest = max if dest < min
    break unless next_1 == dest || next_2 == dest || next_3 == dest
  end
  
  raise "#{dest} is nil" if ring[dest].nil?
  ring[next_3] = ring[dest]
  ring[dest] = next_1
  next_cup = ring[current_cup]

  return ring, next_cup
end

100.times do
  ring, current_cup = move(ring, current_cup, 1, 9)
end

r = ring[1]
until r == 1
  print(r)
  r = ring[r]
end
puts ""

start = input.max + 1
end_val = 1_000_000

(start..end_val).each do |i|
  input << i
end

ring = {}

current_cup = input[0]

input.each_with_index do |i, idx|
  ring[input[idx-1]] = i
end

labels = ring.keys
min = labels.min
max = labels.max

10_000_000.times do |i|
  ring, current_cup = move(ring, current_cup, min, max)
end

a = ring[1]
b = ring[a]

p a * b

