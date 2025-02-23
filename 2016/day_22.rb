require "set"
lines = File.readlines("./resources/input-22").map(&:strip)

Node = Struct.new(:x, :y, :size, :used, :_avail, :_used_pct) do
  def avail
    size - used
  end
end

# Parse input
nodes = lines.filter { |l| l.start_with?("/dev/grid") }.map do |l|
  Node.new(*l.scan(/\d+/).map(&:to_i))
end

# Part 1: Calculate viable pairs
pairs = Set.new
nodes.each_with_index do |n1, i|
  nodes.each_with_index do |n2, j|
    if n1.used > 0 && n1.used <= n2.avail
      i, j = [i, j].sort
      pairs << [i, j]
    end
  end
end

puts "Part 1: #{pairs.count}"

# Create grid for part 2
max_x = nodes.map(&:x).max
max_y = nodes.map(&:y).max
grid = Array.new(max_y + 1) { Array.new(max_x + 1) }
nodes.each { |n| grid[n.y][n.x] = n }

# Find empty node
empty_node = nodes.find { |n| n.used == 0 }

# Verify no walls in top two rows
def assert_no_walls_in_top(grid)
  top_two_rows = grid[0..1].flatten.compact
  largest = top_two_rows.max_by(&:used)
  too_small = top_two_rows.select { |n| n.size < largest.used }
  raise "#{too_small.size} nodes can't take data of #{largest}" unless too_small.empty?
end

# Find path to move empty node to top row
def naive_move_to_top(empty_node, grid)
  start = [empty_node.y, empty_node.x]
  queue = [start]
  dist = { start => 0 }
  max_y = grid.size - 1
  max_x = grid[0].size - 1

  while (pos = queue.shift)
    y, x = pos
    my_size = grid[y][x].size
    return [dist[pos], x] if y == 0

    [
      ([y - 1, x] if y > 0),
      ([y + 1, x] if y + 1 <= max_y),
      ([y, x - 1] if x > 0),
      ([y, x + 1] if x + 1 <= max_x),
    ].compact.each do |ny, nx|
      next if dist.include?([ny, nx]) || grid[ny][nx].used > my_size
      dist[[ny, nx]] = dist[pos] + 1
      queue << [ny, nx]
    end
  end
end

# Calculate total steps for part 2
def calculate_steps(empty_node, grid)
  assert_no_walls_in_top(grid)

  steps, x = naive_move_to_top(empty_node, grid)
  return nil unless steps

  width = grid[0].size
  steps += width - 2 - x  # Move to (WIDTH - 2, 0)
  steps += 1              # Move goal data
  steps + 5 * (width - 2) # 5 steps per position for remaining moves
end

result = calculate_steps(empty_node, grid)
puts "Part 2: #{result}"
