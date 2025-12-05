struct Point
  property x : Int32
  property y : Int32

  def initialize(@x : Int32, @y : Int32)
  end

  def neighbors : Array(Point)
    [
      Point.new(self.x - 1, self.y - 1),
      Point.new(self.x, self.y - 1),
      Point.new(self.x + 1, self.y - 1),
      Point.new(self.x - 1, self.y),
      Point.new(self.x + 1, self.y),
      Point.new(self.x - 1, self.y + 1),
      Point.new(self.x, self.y + 1),
      Point.new(self.x + 1, self.y + 1),
    ]
  end
end

class Day04
  def self.part_1(input : String) : Int32
    map = Hash(Point, Char).new

    input.split("\n").each_with_index do |line, y|
      line.chars.each_with_index do |ch, x|
        pt = Point.new(x, y)

        map[pt] = ch if ch == '@'
      end
    end

    c = map.count do |pt, ch|
      neighbors = pt.neighbors

      neighbors.count { |pt_2| map[pt_2]? == '@' } < 4
    end

    c
  end

  def self.part_2(input : String) : Int32
    map = Hash(Point, Char?).new

    input.split("\n").each_with_index do |line, y|
      line.chars.each_with_index do |ch, x|
        pt = Point.new(x, y)

        map[pt] = ch if ch == '@'
      end
    end

    sum = 0i32

    loops = 0

    while true
      val = map.count do |pt, ch|
        neighbors = pt.neighbors

        count = neighbors.count { |pt_2| map[pt_2]? == '@' }

        if count < 4
          map.delete(pt)
        end

        count < 4
      end

      break if val == 0

      break if loops > 100

      loops += 1

      sum += val
    end

    sum
  end
end
