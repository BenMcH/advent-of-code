Nanobot = Struct.new(:x, :y, :z, :radius) do
  def manhattan_distance(other)
    (x - other.x).abs + (y - other.y).abs + (z - other.z).abs
  end
end

nanobots = File.read("./inputs/day23.txt").scan(/pos=<(-?\d+),(-?\d+),(-?\d+)>, r=(\d+)/).map do |x, y, z, radius|
  x = x.to_i
  y = y.to_i
  z = z.to_i
  radius = radius.to_i
  Nanobot.new(x, y, z, radius)
end

count = Hash.new(0)

nanobots.each do |bot|
  count[bot] = nanobots.count do |other|
    distance = bot.manhattan_distance(other)
    distance <= bot.radius
  end
end

max = nanobots.max_by { |bot| bot.radius }

puts "Part 1: #{count[max]}"

# Part 2
# Find the coordinate that is in range of the most nanobots
# If there are multiple, choose the one with the smallest Manhattan distance from (0,0,0)

# We'll use a binary search approach to narrow down the search space
def count_bots_in_range(nanobots, x, y, z)
  point = Nanobot.new(x, y, z, 0)
  nanobots.count do |bot|
    distance = bot.manhattan_distance(point)
    distance <= bot.radius
  end
end

# Find the bounds of our search space
min_x = nanobots.map(&:x).min
max_x = nanobots.map(&:x).max
min_y = nanobots.map(&:y).min
max_y = nanobots.map(&:y).max
min_z = nanobots.map(&:z).min
max_z = nanobots.map(&:z).max

# We'll use a divide and conquer approach, splitting the space into boxes
# Start with a large grain size and refine it
grain_size = 2**20
best_count = 0
best_distance = Float::INFINITY
best_pos = Nanobot.new(0, 0, 0, 0)

while grain_size >= 1
  new_best_found = false
  
  # Explore around the current best position
  ((best_pos.x - grain_size * 3)..(best_pos.x + grain_size * 3)).step(grain_size) do |x|
    ((best_pos.y - grain_size * 3)..(best_pos.y + grain_size * 3)).step(grain_size) do |y|
      ((best_pos.z - grain_size * 3)..(best_pos.z + grain_size * 3)).step(grain_size) do |z|
        bots_in_range = count_bots_in_range(nanobots, x, y, z)
        distance = x.abs + y.abs + z.abs
        
        if bots_in_range > best_count || (bots_in_range == best_count && distance < best_distance)
          best_count = bots_in_range
          best_distance = distance
          best_pos.x = x
          best_pos.y = y
          best_pos.z = z
          new_best_found = true
        end
      end
    end
  end
  
  # If we didn't find a better position, reduce the grain size
  grain_size >>= 2 if !new_best_found || grain_size == 1
end

puts "Part 2: #{best_distance}"
