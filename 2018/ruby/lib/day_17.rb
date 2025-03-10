require 'set'
min_y = Float::INFINITY
max_y = -Float::INFINITY

map = Hash.new(".")
input = File.read("./inputs/day17.txt").split("\n").each do |line|
  a, b1, b2 = line.scan(/\d+/).map(&:to_i)
  a_char = line[0] == "x" ? :x : :y

  min_y = [min_y, a_char == :x ? b1 : a].min
  max_y = [max_y, a_char == :x ? b2 : a].max

  (b1..b2).each { |b| map[a_char == :x ? [b, a] : [a, b]] = "#" }
end

def add_water(map, max_y, x = 500, y = 1, filled = Set.new)
  return if y >= max_y || filled.include?([y, x]) || map[[y, x]] == "#"

  filled.add([y, x])
  map[[y, x]] = "|"

  if map[[y + 1, x]] == "."
    add_water(map, max_y, x, y + 1, filled)
    return if map[[y + 1, x]] == "|"
  end

  left_x, right_x = x, x
  
  movable = [".", "|"]
  immovable = ["#", "~"]

  while movable.include?(map[[y, left_x - 1]]) && immovable.include?(map[[y + 1, left_x]])
    left_x -= 1
    map[[y, left_x]] = "|"
  end

  while movable.include?(map[[y, right_x + 1]]) && immovable.include?(map[[y + 1, right_x]])
    right_x += 1
    map[[y, right_x]] = "|"
  end

  left_wall = map[[y, left_x - 1]] == "#"
  right_wall = map[[y, right_x + 1]] == "#"
  
  if left_wall && right_wall
    (left_x..right_x).each { |col| map[[y, col]] = "~" }
    add_water(map, max_y, x, y - 1, filled)
  else
    # If open edge, let water continue spilling down
    add_water(map, max_y, left_x, y + 1, filled) unless left_wall
    add_water(map, max_y, right_x, y + 1, filled) unless right_wall
  end
end

add_water(map, max_y)

p map.values.count { |v| v != "#" }
p map.values.count { |v| v == "~" }
