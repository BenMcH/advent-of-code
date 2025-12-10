class Day09
  def self.part_1(input : String)
    input.lines.map(&.split(",").map(&.to_i64))
      .each_combination(2)
      .reduce(0) do |acc, arr|
        x1, y1, x2, y2 = arr.flatten
        area = ((x1 - x2).abs + 1) * ((y1 - y2).abs + 1)
        [area, acc].max
      end
  end

  def self.part_2(input : String)
    map = [] of Point
    areas = [] of Tuple(Point, Point, Int64)
    lines = input.lines
    lines << lines[0] # Connect last to first

    points = lines.map(&.split(",").map(&.to_i32))

    points
      .each_cons(2) do |arrs|
        x1, y1, x2, y2 = arrs.flatten

        if x1 == x2
          y_range = y1 < y2 ? (y1..y2) : (y2..y1)
          y_range.each do |y|
            map << Point.new(x1, y)
          end
        elsif y1 == y2
          x_range = x1 < x2 ? (x1..x2) : (x2..x1)
          x_range.each do |x|
            map << Point.new(x, y1)
          end
        end
      end

    points.each_combination(2) do |points|
      x1, y1, x2, y2 = points.flatten
      
      x_min = [x1, x2].min.to_i64
      x_max = [x1, x2].max.to_i64
      y_min = [y1, y2].min.to_i64
      y_max = [y1, y2].max.to_i64

      size = (x_max - x_min + 1) * (y_max - y_min + 1)

      areas << { Point.new(x1, y1), Point.new(x2, y2), -size.to_i64 }
    end
    
    areas.unstable_sort_by!(&.last)

    valid_max_size = 0_i64
    areas.each do |area|
      a, b, size = area
      
      x_min, x_max = [a.x, b.x].minmax
      y_min, y_max = [a.y, b.y].minmax
      

      valid_max_size = -size
      break if map.all? { |k| k.x <= x_min || k.x >= x_max || k.y <= y_min || k.y >= y_max }
    end

    valid_max_size
  end
end
