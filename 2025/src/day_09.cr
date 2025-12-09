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
    0
  end
end
