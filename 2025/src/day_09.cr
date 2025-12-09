class Day09
  def self.part_1(input : String) : Int64
    points = input.lines.map do |line|
      line.split(",").map(&.to_i64)
    end

    corners = points.combinations(2)

    corners.map do |arr|
      a, b = arr
      x1, y1 = a
      x2, y2 = b

      x_width = (x1 - x2).abs + 1
      y_height = (y1 - y2).abs + 1
      x_width * y_height
    end.max
  end

  def self.part_2(input : String) : Int32
    0
  end
end
