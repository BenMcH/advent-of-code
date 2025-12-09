class Day09
  def self.part_1(input : String)
    input.lines.map(&.split(",").map(&.to_i64))
      .combinations(2)
      .reduce(0) do |acc, arr|
        x1, y1, x2, y2 = arr.flatten
        area = ((x1 - x2).abs + 1) * ((y1 - y2).abs + 1)
        [area, acc].max
      end
  end

  def self.part_2(input : String)
    map = Hash(Point, Char).new(' ')

    min_x = 1_000_000_000
    max_x = -1_000_000_000
    min_y = 1_000_000_000
    max_y = -1_000_000_000

    lines = input.lines
    lines << lines[0] # Connect last to first

    areas = [] of Tuple(Point, Int32)

    points = lines.map(&.split(",").map(&.to_i32))

    points
      .each_cons(2) do |arrs|
        x1, y1, x2, y2 = arrs.flatten

        min_x = [min_x, x1, x2].min
        max_x = [max_x, x1, x2].max
        min_y = [min_y, y1, y2].min
        max_y = [max_y, y1, y2].max

        if x1 == x2
          y_range = y1 < y2 ? (y1..y2) : (y2..y1)
          y_range.each do |y|
            map[Point.new(x1, y)] ||= 'X'
          end
        elsif y1 == y2
          x_range = x1 < x2 ? (x1..x2) : (x2..x1)
          x_range.each do |x|
            map[Point.new(x, y1)] ||= 'X'
          end
        end
      end

    valid_max_size = 0i64
    points.combinations(2).each do |points|
      a, b = points
      x1, y1 = a
      x2, y2 = b

      x_min = [x1, x2].min.to_i64
      x_max = [x1, x2].max.to_i64
      y_min = [y1, y2].min.to_i64
      y_max = [y1, y2].max.to_i64

      size = (x_max - x_min + 1) * (y_max - y_min + 1)

      next if size <= valid_max_size

      valid = map.all? do |k, v|
        x, y = k.x, k.y

        x <= x_min || x >= x_max || y <= y_min || y >= y_max
      end

      if valid
        valid_max_size = [size, valid_max_size].max
        p valid_max_size
      end
    end

    valid_max_size
  end
end
