require "../helpers"

class Day04
  def self.parse(input : String)
    map = Hash(Point, Char).new
    input.lines.each_with_index do |line, y|
      line.chars.each_with_index do |ch, x|
        pt = Point.new(x, y)
        map[pt] = ch if ch == '@'
      end
    end
    map
  end

  def self.part_1(input : String) : Int32
    map = parse(input)
    map.count do |pt, ch|
      pt.neighbors_8.count { |pt_2| map[pt_2]? == '@' } < 4
    end
  end

  def self.part_2(input : String) : Int32
    map = parse(input)

    sum = 0i32

    while true
      val = map.count do |pt, ch|
        count = pt.neighbors_8.count { |pt_2| map[pt_2]? == '@' } < 4
        map.delete(pt) if count
        count
      end
      break if val == 0
      sum += val
    end
    sum
  end
end
