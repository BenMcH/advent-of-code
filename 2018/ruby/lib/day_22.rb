depth, x, y = File.read("./inputs/day22.txt").scan(/\d+/).map(&:to_i)

Loc = Struct.new(:x, :y) do

end


target = Loc.new(x, y)
cave_entrance = Loc.new(0, 0)

ROCK = 0
WET = 1
NARROW = 2

erosion_map = Hash.new do |h, k|
  x = k.x
  y = k.y
  
  geologic_index = if x == 0 && y == 0
    0
  elsif x == target.x && y == target.y
    0
  elsif y == 0
    x * 16807
  elsif x == 0
    y * 48271
  else
    erosion_map[Loc.new(x - 1, y)] * erosion_map[Loc.new(x, y - 1)]
  end
  
  erosion_level = (geologic_index + depth) % 20183
  
  h[k] = erosion_level
end

risk_map = Hash.new do |h, k|
  x = k.x
  y = k.y
  
  erosion_level = erosion_map[k]
  risk = erosion_level % 3

  h[k] = risk
end

ans = (0..x).sum do |i|
  (0..y).sum do |j|
    loc = Loc.new(i, j)
    risk_map[loc]
  end
end

p ans
