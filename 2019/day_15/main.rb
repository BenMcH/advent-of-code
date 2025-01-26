require_relative "../intcode.rb"

input = File.read("./input.txt")
computer = Intcode.new(input)

NORTH = 1
SOUTH = 2
WEST = 3
EAST = 4

HIT_WALL = 0
MOVED = 1
MOVED_OXYGEN = 2

# Unknown will be ?
# Open spaces will be .
# Starting point will be *
# Walls will be #
# Oxygen system will be O
map = Hash.new('?')

loc = [0, 0]
map[loc] = '*'
def backtrack(loc, map, computer, unexplored)
	unexplored << loc

	dirs = [
		[NORTH, [loc[0] - 1, loc[1]], SOUTH],  # direction, new_loc, reverse_direction
		[SOUTH, [loc[0] + 1, loc[1]], NORTH],
		[WEST,  [loc[0], loc[1] - 1], EAST],
		[EAST,  [loc[0], loc[1] + 1], WEST]
	]

	unexplored_dirs = dirs.select { |_, d, _| !map.key?(d) }

	unexplored_dirs.each do |direction, new_loc, reverse|
		computer.inputs << direction

		computer.step until computer.outputs.any?
		result = computer.outputs.shift

		case result
		when HIT_WALL
			map[new_loc] = '#'
		when MOVED
			map[new_loc] = '.' if map[new_loc] == '?'
			backtrack(new_loc, map, computer, unexplored)
			# Move back
			computer.inputs << reverse
			computer.step until computer.outputs.any?
			computer.outputs.shift  # Clear the output
		when MOVED_OXYGEN
			map[new_loc] = 'O'
			backtrack(new_loc, map, computer, unexplored)
			# Move back
			computer.inputs << reverse
			computer.step until computer.outputs.any?
			computer.outputs.shift  # Clear the output
		end
	end
end

backtrack(loc, map, computer, [])

def find_shortest_path(map, start, target)
  queue = [[start, [start]]]  # Each element is [current_pos, path_so_far]
  visited = Set.new([start])

  while !queue.empty?
    current, path = queue.shift
    
    return path if current == target

    # Try all four directions
    [[0, 1], [0, -1], [1, 0], [-1, 0]].each do |dx, dy|
      next_pos = [current[0] + dx, current[1] + dy]
      next if visited.include?(next_pos) || map[next_pos] == '#' || !map.key?(next_pos)

      visited.add(next_pos)
      queue.push([next_pos, path + [next_pos]])
    end
  end
end

def simulate_oxygen_spread(map, start_pos)
  minutes = 0
  current_positions = [start_pos]
  
  # Keep going until no new positions are filled
  while !current_positions.empty?
    new_positions = []
    
    current_positions.each do |pos|
      [[0, 1], [0, -1], [1, 0], [-1, 0]].each do |dx, dy|
        next_pos = [pos[0] + dx, pos[1] + dy]
        # Spread to empty spaces (. or +)
        if map[next_pos] == '.' || map[next_pos] == '+'
          map[next_pos] = 'O'
          new_positions << next_pos
        end
      end
    end
    
    current_positions = new_positions
    minutes += 1 unless new_positions.empty?
  end
  
  minutes
end

# Find the oxygen system
oxygen_pos = map.find { |pos, val| val == 'O' }&.first
start_pos = map.find { |pos, val| val == '*' }&.first

if oxygen_pos && start_pos
  path = find_shortest_path(map, start_pos, oxygen_pos)
  if path
    puts "Found path to oxygen system! Length: #{path.length - 1} steps"
    # Mark the path with + symbols
    path[1..-2].each do |pos|  # Skip start and end positions
      map[pos] = '+'
    end
  else
    puts "No path found to oxygen system!"
  end
  
  minutes = simulate_oxygen_spread(map, oxygen_pos)
  puts "Minutes to fill with oxygen: #{minutes}"
end
