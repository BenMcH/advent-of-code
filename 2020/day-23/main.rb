input = File.read("./data.txt").strip.chars.map(&:to_i)

ring = {}

input.each_with_index do |i, idx|
  ring[input[idx-1]] = i
end

current_cup = input[0]

def move(ring, current_cup, min, max, n = 1)
  n.times do
    next_1 = ring[current_cup]
    next_2 = ring[next_1]
    next_3 = ring[next_2]

    dest = current_cup - 1
    while dest == 0 || next_1 == dest || next_2 == dest || next_3 == dest
      dest = dest == 0 ? max : (dest - 1)
    end

    ring[current_cup] = ring[next_3]
    ring[next_3] = ring[dest]
    ring[dest] = next_1
    current_cup = ring[current_cup]
  end

  return current_cup
end

current_cup = move(ring, current_cup, 1, 9, 100)

r = ring[1]
until r == 1
  print(r)
  r = ring[r]
end
puts ""

start = 10
end_val = 1_000_000

input += (start..end_val).to_a

ring = {}

current_cup = input[0]

input.each_with_index do |i, idx|
  ring[input[idx-1]] = i
end

current_cup = move(ring, current_cup, 1, 1_000_000, 10_000_000)

a = ring[1]
b = ring[a]

p a * b

