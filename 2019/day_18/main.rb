require 'set'

input = File.readlines("./input.txt").map(&:strip).map(&:chars)

# Build the map
map = {}
keys = {}
key_positions = {}
start_pos = nil
key_count = 0

def key_bit(ch)
	ch.ord - 'a'.ord
end

def door_bit(ch)
	ch.ord - 'A'.ord
end

input.each_with_index do |line, y|
  line.each_with_index do |ch, x|
    pos = [x, y]
    
    if ch == '@'
      start_pos = pos
      map[pos] = '.'
    elsif ch == '#'
      # Skip walls
    else
      map[pos] = ch
      
      if ('a'..'z').include?(ch)
        key_bit = 1 << key_bit(ch)
        keys[ch] = key_bit
        key_positions[key_bit] = pos
        key_count += 1
      end
    end
  end
end

# All keys bit mask
all_keys = (1 << key_count) - 1

# Calculate distances between important positions
def calculate_distances(start_pos, map, keys)
  distances = {}
  
  # BFS from start_pos
  queue = [[start_pos, 0, 0]] # [position, distance, doors_needed]
  visited = {start_pos => 0}
  
  while !queue.empty?
    pos, dist, doors = queue.shift
    
    # Check if position has a key
    if ('a'..'z').include?(map[pos])
      key_bit = 1 << key_bit(map[pos])
      distances[key_bit] = [dist, doors]
    end
    
    # Check all four directions
    [[0, 1], [1, 0], [0, -1], [-1, 0]].each do |dx, dy|
      new_pos = [pos[0] + dx, pos[1] + dy]
      next unless map.include?(new_pos) # Skip if out of bounds or wall
      
      new_doors = doors
      if ('A'..'Z').include?(map[new_pos])
        door_bit = 1 << door_bit(map[new_pos])
        new_doors |= door_bit
      end
      
      # Only visit if it's a shorter path
      if !visited[new_pos] || visited[new_pos] > dist + 1
        visited[new_pos] = dist + 1
        queue << [new_pos, dist + 1, new_doors]
      end
    end
  end
  
  distances
end

# Build graph of key-to-key distances
key_distances = {}
key_distances[0] = calculate_distances(start_pos, map, keys)

keys.each do |key, key_bit|
  key_distances[key_bit] = calculate_distances(key_positions[key_bit], map, keys)
end

# Fast shortest path algorithm using memoization
def find_shortest_path(key_distances, all_keys)
  # Memoization cache
  memo = {}
  
  # Recursive helper function
  def dfs(current_key, collected_keys, key_distances, all_keys, memo)
    # Check if we have all keys
    return 0 if collected_keys == all_keys
    
    # Check if we've already computed this state
    state = [current_key, collected_keys]
    return memo[state] if memo.include?(state)
    
    best_distance = Float::INFINITY
    
    # Try to collect each remaining key
    key_distances[current_key].each do |next_key, (distance, doors)|
      # Skip if we already have this key
      next if (collected_keys & next_key) != 0
      
      # Check if we have all required keys to access this door
      next if (doors & ~collected_keys) != 0
      
      # Recursively find the best path
      remaining_distance = dfs(next_key, collected_keys | next_key, key_distances, all_keys, memo)
      total_distance = distance + remaining_distance
      
      best_distance = [best_distance, total_distance].min
    end
    
    # Cache and return
    memo[state] = best_distance
    best_distance
  end
  
  # Start search
  dfs(0, 0, key_distances, all_keys, memo)
end

puts "Calculating minimum steps..."
min_steps = find_shortest_path(key_distances, all_keys)
puts "Minimum steps required: #{min_steps}"
