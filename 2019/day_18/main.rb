# Unified maze solver that supports both part 1 (single robot) and part 2 (four robots)
require 'set'

class MazeSolver
  def initialize(input_file)
    @input = File.readlines(input_file).map(&:strip).map(&:chars)
    @map = {}
    @keys = {}
    @key_positions = {}
    @start_positions = []
    @key_count = 0

    parse_map
    @all_keys = (1 << @key_count) - 1
  end

  def parse_map
    @input.each_with_index do |line, y|
      line.each_with_index do |ch, x|
        pos = [x, y]
        
        if ch == '@'
          @start_positions << pos
          @map[pos] = '.'
        elsif ch == '#'
          # Skip walls
        else
          @map[pos] = ch
          
          if ('a'..'z').include?(ch)
            key_bit = 1 << (ch.ord - 'a'.ord)
            @keys[ch] = key_bit
            @key_positions[key_bit] = pos
            @key_count += 1
          end
        end
      end
    end
  end

  def split_map
    return if @start_positions.length != 1
    
    # Find the original start position
    start = @start_positions[0]
    x, y = start
    
    # Create the walls for the 4 quadrants
    [[-1, -1], [0, -1], [1, -1], 
     [-1, 0],  [0, 0],  [1, 0], 
     [-1, 1],  [0, 1],  [1, 1]].each do |dx, dy|
      @map[[x + dx, y + dy]] = '#'
    end
    
    # Add the four robots
    @start_positions = [[x-1, y-1], [x+1, y-1], [x-1, y+1], [x+1, y+1]]
    @start_positions.each do |pos|
      @map[pos] = '.'
    end
  end

  def find_accessible_keys(start_pos)
    accessible = {}
    
    # BFS from start_pos
    queue = [[start_pos, 0, 0]] # [position, distance, doors_needed]
    visited = {start_pos => [0, 0]}
    
    while !queue.empty?
      pos, dist, doors = queue.shift
      
      # Check if position has a key
      if ('a'..'z').include?(@map[pos])
        key_bit = 1 << (@map[pos].ord - 'a'.ord)
        accessible[key_bit] = [dist, doors]
      end
      
      # Check all four directions
      [[0, 1], [1, 0], [0, -1], [-1, 0]].each do |dx, dy|
        new_pos = [pos[0] + dx, pos[1] + dy]
        next unless @map.include?(new_pos) && @map[new_pos] != '#' # Skip if wall or out of bounds
        
        new_doors = doors
        if ('A'..'Z').include?(@map[new_pos])
          door_bit = 1 << (@map[new_pos].ord - 'A'.ord)
          new_doors |= door_bit
        end
        
        # Only visit if it's a shorter path or new door requirements
        if !visited[new_pos] || visited[new_pos][0] > dist + 1
          visited[new_pos] = [dist + 1, new_doors]
          queue << [new_pos, dist + 1, new_doors]
        end
      end
    end
    
    accessible
  end

  def build_access_maps
    # Get keys accessible from each robot start position
    @robot_keys = {}
    @start_positions.each_with_index do |start_pos, i|
      @robot_keys[i] = find_accessible_keys(start_pos)
    end

    # Build map of key-to-key distances
    @key_distances = {}
    @keys.each do |key, key_bit|
      @key_distances[key_bit] = find_accessible_keys(@key_positions[key_bit])
    end
  end

  def find_shortest_path_single_robot
    # Cache for memoization
    memo = {}
    
    # Helper function for DFS with memoization
    def dfs_single(current_key, collected_keys, memo)
      # Base case: all keys collected
      return 0 if collected_keys == @all_keys
      
      # Check memo
      state = [current_key, collected_keys]
      return memo[state] if memo.include?(state)
      
      best_distance = Float::INFINITY
      
      accessible_keys = current_key == 0 ? @robot_keys[0] : @key_distances[current_key]
      
      # Try collecting each accessible key
      accessible_keys.each do |key_bit, (distance, doors_needed)|
        # Skip if we already have this key
        next if (collected_keys & key_bit) != 0
        
        # Skip if we don't have keys to open required doors
        next if (doors_needed & ~collected_keys) != 0
        
        # Recursively find best path
        remaining_distance = dfs_single(key_bit, collected_keys | key_bit, memo)
        
        total_distance = distance + remaining_distance
        best_distance = [best_distance, total_distance].min
      end
      
      # Cache result
      memo[state] = best_distance
      best_distance
    end
    
    # Start with robot at initial position (represented by 0)
    dfs_single(0, 0, memo)
  end

  def find_shortest_path_multi_robot
    # Cache for memoization
    memo = {}
    
    # Helper function for DFS with memoization
    def dfs_multi(robots, collected_keys, memo)
      # Base case: all keys collected
      return 0 if collected_keys == @all_keys
      
      # Check memo
      state = [robots.dup, collected_keys]
      return memo[state] if memo.include?(state)
      
      best_distance = Float::INFINITY
      
      # Try moving each robot
      robots.each_with_index do |robot, robot_idx|
        # Get keys this robot can access
        accessible_keys = robot == 0 ? @robot_keys[robot_idx] : @key_distances[robot]
        
        # Try collecting each accessible key
        accessible_keys.each do |key_bit, (distance, doors_needed)|
          # Skip if we already have this key
          next if (collected_keys & key_bit) != 0
          
          # Skip if we don't have keys to open required doors
          next if (doors_needed & ~collected_keys) != 0
          
          # Create a new robot state
          new_robots = robots.dup
          new_robots[robot_idx] = key_bit
          
          # Recursively find best path
          remaining_distance = dfs_multi(new_robots, collected_keys | key_bit, memo)
          
          total_distance = distance + remaining_distance
          best_distance = [best_distance, total_distance].min
        end
      end
      
      # Cache result
      memo[state] = best_distance
      best_distance
    end
    
    # Start with robots at their initial positions (represented by 0)
    initial_robots = [0] * @robot_keys.length
    dfs_multi(initial_robots, 0, memo)
  end

  def solve_part1
    # Use original map with single robot
    @start_positions = [@start_positions.first] if @start_positions.length > 1
    build_access_maps
    puts "Solving Part 1 (single robot)..."
    min_steps = find_shortest_path_single_robot
    puts "Part 1 solution: #{min_steps}"
    min_steps
  end

  def solve_part2
    # Split the map for part 2
    split_map
    build_access_maps
    puts "Solving Part 2 (four robots)..."
    min_steps = find_shortest_path_multi_robot
    puts "Part 2 solution: #{min_steps}"
    min_steps
  end

  def solve_both
    part1 = solve_part1
    
    # Reset and solve part 2
    @start_positions = []
    parse_map
    part2 = solve_part2
    
    [part1, part2]
  end
end

solver = MazeSolver.new("./input.txt")

solver.solve_both
