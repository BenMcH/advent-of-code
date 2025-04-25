require 'set'

instructions = File.read("./inputs/day20.txt").strip

Loc = Struct.new(:y, :x) do
  def up
    Loc.new(y - 1, x)
  end

  def down
    Loc.new(y + 1, x)
  end

  def left
    Loc.new(y, x - 1)
  end

  def right
    Loc.new(y, x + 1)
  end 
end

def options(regex, options = [])
  regex = regex.gsub("^", "").gsub("$", "")
  
  # Base case
  return [""] if regex.empty?
  
  result = []
  
  # Check for alternation at the top level
  parts = split_alternation(regex)
  if parts.size > 1
    parts.each do |part|
      result += options(part)
    end
    return options + result
  end
  
  # Find the first group, if any
  i = regex.index("(")
  
  if i.nil?
    # No groups, just return the regex
    return options + [regex]
  else
    # Process the part before the group
    prefix = regex[0...i]
    
    # Find the matching closing parenthesis
    j = find_matching_paren(regex, i)
    
    # Extract the group content
    group_content = regex[(i+1)...j]
    
    # Get all options for the group
    group_options = options(group_content)
    
    # Process the part after the group
    suffix = regex[(j+1)..-1]
    
    # Combine all parts
    group_options.each do |opt|
      options(suffix).each do |suf|
        result << prefix + opt + suf
      end
    end
    
    return options + result
  end
end

def split_alternation(regex)
  parts = []
  current_part = ""
  depth = 0
  
  regex.chars.each do |char|
    if char == "("
      depth += 1
      current_part += char
    elsif char == ")"
      depth -= 1
      current_part += char
    elsif char == "|" && depth == 0
      parts << current_part
      current_part = ""
    else
      current_part += char
    end
  end
  
  parts << current_part if !current_part.empty?
  return parts
end

def find_matching_paren(regex, open_index)
  depth = 1
  i = open_index + 1
  
  while i < regex.length && depth > 0
    depth += 1 if regex[i] == "("
    depth -= 1 if regex[i] == ")"
    i += 1
  end
  
  return i - 1
end

# Test cases for regex parsing
raise "Failed simple case" unless options("^WNE$") == ["WNE"]
simple_group = options("^W(N)E$")
raise "Failed simple group" unless  simple_group == ["WNE"]
divergent_group = options("^W(N|S)E$")
raise "Failed simple divergent group" unless divergent_group == ["WNE", "WSE"]
super_divergent_group = options("^W(N|(S|W))E$")
raise "Failed super divergent group" unless  super_divergent_group == ["WNE", "WSE", "WWE"]

# Build the map based on the regex instructions
def build_map(instructions)
  doors = Set.new
  rooms = Set.new
  start = Loc.new(0, 0)
  rooms.add(start)
  
  # Process each path option from the regex
  paths = options(instructions)
  
  paths.each do |path|
    current = start
    
    path.chars.each do |dir|
      next_loc = case dir
                 when 'N' then current.up
                 when 'S' then current.down
                 when 'E' then current.right
                 when 'W' then current.left
                 else next
                 end
      
      # Add the door between current and next_loc
      door = [current, next_loc].sort_by { |loc| [loc.y, loc.x] }
      doors.add(door)
      
      # Move to the next room
      current = next_loc
      rooms.add(current)
    end
  end
  
  [rooms, doors]
end

# Find the furthest room using BFS
def find_furthest_room(rooms, doors)
  start = Loc.new(0, 0)
  queue = [[start, 0]] # [location, distance]
  visited = Set.new([start])
  max_distance = 0
  
  until queue.empty?
    current, distance = queue.shift
    max_distance = distance if distance > max_distance
    
    # Find all neighboring rooms
    neighbors = rooms.select do |room|
      # Check if there's a door between current and room
      door = [current, room].sort_by { |loc| [loc.y, loc.x] }
      doors.include?(door) && !visited.include?(room)
    end
    
    neighbors.each do |neighbor|
      visited.add(neighbor)
      queue.push([neighbor, distance + 1])
    end
  end
  
  max_distance
end

# More efficient approach using directed graph and BFS
def navigate_map(instructions)
  # Initialize the map with the starting position at (0,0)
  map = {}
  start_loc = Loc.new(0, 0)
  map[start_loc] = {} # Each location points to a hash of neighbors
  
  # Process the regex to build the map directly without generating all paths
  stack = []
  branch_points = []
  current_pos = start_loc
  
  instructions = instructions[1...-1] # Remove ^ and $
  
  instructions.chars.each do |char|
    case char
    when '('
      # Save current position for branching
      branch_points.push(current_pos)
      stack.push([]) # Stack to collect all end positions for this branch
    when '|'
      # End of a branch option, save current position and go back to branch start
      stack.last.push(current_pos)
      current_pos = branch_points.last
    when ')'
      # End of all branch options
      stack.last.push(current_pos) # Add the last branch end position
      end_positions = stack.pop
      current_pos = branch_points.pop
      
      # Current position is now all possible end positions from the branches
      current_pos = end_positions.last
    when 'N', 'S', 'E', 'W'
      next_pos = case char
                 when 'N' then current_pos.up
                 when 'S' then current_pos.down
                 when 'E' then current_pos.right
                 when 'W' then current_pos.left
                 end
      
      # Ensure both locations exist in the map
      map[current_pos] ||= {}
      map[next_pos] ||= {}
      
      # Add bidirectional connections
      map[current_pos][next_pos] = 1
      map[next_pos][current_pos] = 1
      
      current_pos = next_pos
    end
  end
  
  # Use BFS to find the furthest room
  queue = [[start_loc, 0]] # [location, distance]
  visited = {start_loc => 0}
  max_distance = 0
  
  until queue.empty?
    current, distance = queue.shift
    max_distance = distance if distance > max_distance
    
    map[current].each_key do |neighbor|
      next if visited.key?(neighbor)
      
      visited[neighbor] = distance + 1
      queue.push([neighbor, distance + 1])
    end
  end
  
  [max_distance, visited.count { |_, dist| dist >= 1000 }]
end

# Solve Part 1 and Part 2
furthest_room, rooms_far_away = navigate_map(instructions)
puts "Part 1: The furthest room requires passing through #{furthest_room} doors."
puts "Part 2: There are #{rooms_far_away} rooms that pass through at least 1000 doors."

