depth, x, y = File.read("./inputs/day22.txt").scan(/\d+/).map(&:to_i)

Loc = Struct.new(:x, :y) do
  def neighbors
    [
      Loc.new(x - 1, y),
      Loc.new(x + 1, y),
      Loc.new(x, y - 1),
      Loc.new(x, y + 1)
    ].select { |loc| loc.x >= 0 && loc.y >= 0 }
  end

  def manhattan_distance(other)
    (x - other.x).abs + (y - other.y).abs
  end
end

target = Loc.new(x, y)
cave_entrance = Loc.new(0, 0)

ROCK = 0
WET = 1
NARROW = 2

# Tools
TORCH = 0
CLIMBING = 1
NEITHER = 2

# Valid tools per region type
VALID_TOOLS = {
  ROCK => [TORCH, CLIMBING],
  WET => [CLIMBING, NEITHER],
  NARROW => [TORCH, NEITHER]
}

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

# Part 1: Calculate total risk level
ans = (0..target.x).sum do |i|
  (0..target.y).sum do |j|
    loc = Loc.new(i, j)
    risk_map[loc]
  end
end

puts "Part 1: #{ans}"

# Part 2: Find shortest path from entrance to target
require 'set'
require 'algorithms'
include Containers

# State = location + current tool
State = Struct.new(:loc, :tool) do
  def to_s
    "State(loc=(#{loc.x},#{loc.y}), tool=#{tool})"
  end
  
  def eql?(other)
    loc.x == other.loc.x && loc.y == other.loc.y && tool == other.tool
  end
  
  def hash
    [loc.x, loc.y, tool].hash
  end
end

# Priority queue setup for Dijkstra's algorithm
queue = PriorityQueue.new
queue.push(State.new(cave_entrance, TORCH), -0)

min_time = Hash.new(Float::INFINITY)
min_time[State.new(cave_entrance, TORCH)] = 0

target_with_torch = State.new(target, TORCH)
min_time_to_target = Float::INFINITY

until queue.empty?
  state = queue.pop
  current_time = min_time[state]
  current_loc = state.loc
  current_tool = state.tool
  
  # If we've already found a better path to the target with a torch, skip
  if current_time > min_time_to_target
    next
  end
  
  # If we've reached the target with a torch, update the min time
  if state.eql?(target_with_torch) && current_time < min_time_to_target
    min_time_to_target = current_time
  end
  
  # Consider switching tools in the current region
  region_type = risk_map[current_loc]
  VALID_TOOLS[region_type].each do |new_tool|
    if new_tool != current_tool
      new_state = State.new(current_loc, new_tool)
      new_time = current_time + 7
      
      if new_time < min_time[new_state]
        min_time[new_state] = new_time
        priority = -(new_time + current_loc.manhattan_distance(target))
        queue.push(new_state, priority)
      end
    end
  end
  
  # Consider moving to neighboring regions
  current_loc.neighbors.each do |neighbor|
    neighbor_region_type = risk_map[neighbor]
    
    # Check which tools are valid in the neighbor region
    VALID_TOOLS[neighbor_region_type].each do |neighbor_tool|
      new_state = State.new(neighbor, neighbor_tool)
      new_time = current_time + (neighbor_tool == current_tool ? 1 : 8) # 1 for move, +7 if we need to switch tools
      
      if new_time < min_time[new_state]
        min_time[new_state] = new_time
        priority = -(new_time + neighbor.manhattan_distance(target))
        queue.push(new_state, priority)
      end
    end
  end
end

puts "Part 2: #{min_time_to_target}"
