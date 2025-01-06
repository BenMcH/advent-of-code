require 'set'

class Day06
  Point = Struct.new(:x, :y) do
    def to_s
      "[#{x}, #{y}]"
    end

    def up = Point.new(x, y - 1)
    def down = Point.new(x, y + 1)
    def left = Point.new(x - 1, y)
    def right = Point.new(x + 1, y)

    def neighbors
      [up, down, left, right]
    end

    def closest(points)
      a, b = points.min_by(2) { |p| manhatten_dist(p) }

      a_d = manhatten_dist(a)
      b_d = manhatten_dist(b)

      return nil if a_d == 0
      return nil if a_d == b_d

      return a
    end

    def points_to(other_point)
      raise unless other_point.is_a?(Point)

      if y == other_point.y
        min, max = [x, other_point.x].minmax

        (min..max).map do |x|
          Point.new(x, y)
        end
      elsif x == other_point.x
        min, max = [y, other_point.y].minmax
        (min..max).map do |y|
          Point.new(x, y)
        end
      else
        []
      end
    end

    def manhatten_dist(op)
      (x - op.x).abs + (y - op.y).abs
    end
  end

  def self.bounding_box(points)
    min_x, min_y = Float::INFINITY, Float::INFINITY
    max_x, max_y = -Float::INFINITY, -Float::INFINITY

    points.each do |p|
      min_x = p.x if p.x < min_x
      min_y = p.y if p.y < min_y
      max_x = p.x if p.x > max_x
      max_y = p.y if p.y > max_y
    end

    [
      [min_x, min_y],
      [min_x, max_y],
      [max_x, max_y],
      [max_x, min_y]
    ].map { |p| Point.new(*p) }
  end

  def self.part_1(input)
    nums = input.scan(/\d+/).map(&:to_i)

    points = nums.each_slice(2).map { |pair| Point.new(*pair) }
    
    corners = bounding_box(points)

    all_edges = []
    corners.each_with_index do |c, i|
      corners[i+1..].each do |c2|
        all_edges += c.points_to c2
      end
    end

    inf = all_edges.map do |e|
      points.min_by { |p| e.manhatten_dist(p) }
    end.uniq

    non_inf = points - inf

    closest_cache = {}

    caches = Hash.new do |hash, key|
      hash[key] = Set.new
    end
    non_inf.each do |p|
      cache = caches[p]
      check = p.neighbors

      until check.empty?
        point = check.shift
        next if cache.include?(point)

        if point.closest(points) == p
          cache << point

          point.neighbors.each do |n|
            check << n
          end
        end
      end
    end

    caches.map { |_, v| v.length + 1 }.max
  end
  
  def self.part_2(input, max_manhatten = 10000)
    nums = input.scan(/\d+/).map(&:to_i)

    points = nums.each_slice(2).map { |pair| Point.new(*pair) }
    
    corners = bounding_box(points)

    all_edges = []
    corners.each_with_index do |c, i|
      corners[i+1..].each do |c2|
        all_edges += c.points_to c2
      end
    end

    inf = all_edges.map do |e|
      points.min_by { |p| e.manhatten_dist(p) }
    end.uniq

    non_inf = points - inf

    checked = Set.new
    pts = Set.new

    check = non_inf

    until check.empty?
      pt = check.shift
      next if pts.include?(pt) || checked.include?(pt)
      checked << pt

      tot = 0
      points.each do |p|
        tot += p.manhatten_dist(pt)

        break if tot > max_manhatten
      end

      if tot < max_manhatten
        pts << pt

        check += pt.neighbors
      end
    end

    pts.length
  end
end
