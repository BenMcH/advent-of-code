require 'set'

input = File.readlines("./input.txt", chomp: true).map(&:chars)

Point = Struct.new(:x, :y) do
  def neighbors
    [Point.new(x - 1, y),
     Point.new(x + 1, y),
     Point.new(x, y - 1),
     Point.new(x, y + 1)]
  end
end

@map = Hash.new("#")
@sym_locs = Hash.new { |hash, key| hash[key] = [] }
@sym_map = {}
@width = input.first.length
@height = input.length

def is_letter?(str)
  str =~ /[A-Za-z]/
end

input.each_with_index do |row, y|
  row.each_with_index do |ch, x|
    if ch == '.'
      point = Point.new(x, y)
      @map[point] = "."
      
      id = nil
      if x > 1 && is_letter?(input[y][x-1])
        id = input[y][x-2] + input[y][x-1]
      elsif x < @width - 2 && is_letter?(input[y][x+1])
        id = input[y][x+1] + input[y][x+2]
      elsif y > 1 && is_letter?(input[y-1][x])
        id = input[y-2][x] + input[y-1][x]
      elsif y < @height - 2 && is_letter?(input[y+1][x])
        id = input[y+1][x] + input[y+2][x]
      end

      if id
        @sym_locs[id.to_sym] << point
      end
    end
  end
end

@sym_locs.each do |k, v|
  v.each { |p| @sym_map[p] = k }
end

start = @sym_locs[:AA][0]
goal = @sym_locs[:ZZ][0]

def is_outer_portal?(point)
  point.x <= 2 || point.x >= @width - 3 || point.y <= 2 || point.y >= @height - 3
end

def find_min(start, goal, part_2 = false)
  queue = [[start, 0, 0]] # [position, level, steps]
  visited = Set.new
  
  until queue.empty?
    loc, level, steps = queue.shift

    # If we reach the goal (ZZ) at level 0, return the steps taken.
    return steps if loc == goal && level == 0

    next if visited.include?([loc, level])
    visited << [loc, level]

    loc.neighbors.each do |pt|
      next if @map[pt] != '.'
      
      if @sym_map.key?(pt)
        portal_id = @sym_map[pt]
        target_points = @sym_locs[portal_id]
        other_pt = target_points.find { |p| p != pt }
        
        if part_2
          # If it's a portal other than AA or ZZ, check the level transition
          if portal_id != :AA && portal_id != :ZZ
            if other_pt
              # Transition levels based on outer or inner portal
              new_level = is_outer_portal?(pt) ? level - 1 : level + 1
              next if new_level < 0 # Can't go below level 0
              queue << [other_pt, new_level, steps + 2]
              next
            end
          end
        else
          offset = 2

          if other_pt.nil?
            other_pt = pt 
            offset = 1
          end
          # next if other_pt.nil?
          queue << [other_pt, 0, steps + offset]
          next
        end
      end

      # Regular movement without a portal
      queue << [pt, level, steps + 1]
    end
  end
  
  return -1 # No solution found
end

p find_min(start, goal)
p find_min(start, goal, true)
