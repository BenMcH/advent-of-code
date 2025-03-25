input = File.readlines("./input.txt", chomp: true).map(&:chars)

Point = Struct.new(:x, :y) do
  def neighbors
    [Point.new(x - 1, y),
    Point.new(x + 1, y),
    Point.new(x, y - 1),
    Point.new(x, y + 1)]
  end
end

map = Hash.new("#")
sym_locs = Hash.new { |hash, key| hash[key] = [] }
sym_map = {}

def is_letter?(str)
  str =~ /[A-Za-z]/
end

loc = nil

input.each_with_index do |row, y|
  row.each_with_index do |ch, x|
    if ch == '.'
      point = Point.new(x, y)
      map[point] = "."
      
      id = nil
      if is_letter?(input[y][x-1])
        id = input[y][x-2] + input[y][x-1]
        sym_locs[id.to_sym] << point
      elsif is_letter?(input[y][x+1])
        id = input[y][x+1] + input[y][x+2]
        sym_locs[id.to_sym] << point
      elsif is_letter?(input[y-1][x])
        id = input[y-2][x] + input[y-1][x]
        sym_locs[id.to_sym] << point
      elsif is_letter?(input[y+1][x])
        id = input[y+1][x] + input[y+2][x]
        sym_locs[id.to_sym] << point
      end
    end
  end
end

sym_locs.each do |k, v|
  v.each do |p|
    sym_map[p] = k
  end
end
loc = sym_locs[:AA][0]

min_dist = Float::INFINITY
states = [[loc, Set.new, 0]] # Include step counter

while states.any?
  loc, visited, steps = states.shift
  
  next if visited.include?(loc) || steps > min_dist
  visited = visited.dup << loc
  
  if sym_map[loc] == :ZZ
    min_dist = [min_dist, steps].min
    next
  end

  loc.neighbors.each do |pt|
    next if visited.include?(pt) || map[pt] != '.'
    step_offset = 0
    
    if sym_map.key?(pt)
      target_points = sym_locs[sym_map[pt]]
      other_pt = target_points.find { |p2| p2 != pt }
      if other_pt
        pt = other_pt if other_pt
        step_offset = 1
      end
    end

    states << [pt, visited, steps + step_offset + 1]
  end
end

p min_dist
