class Day01
  private def self.parse_lines(input : String)
    input.lines.map(&.strip).reject(&.empty?)
  end

  private def self.move_delta(direction : Char) : Int32
    direction == 'L' ? -1 : 1
  end

  def self.part_1(input : String) : Int32
    num = 50
    zeros = 0

    parse_lines(input).each do |line|
      direction = line[0]
      distance = line[1..].to_i

      num = (num + move_delta(direction) * distance) % 100
      zeros += 1 if num == 0
    end

    zeros
  end

  def self.part_2(input : String) : Int32
    num = 50
    zeros = 0

    parse_lines(input).each do |line|
      direction = line[0]
      distance = line[1..].to_i
      delta = move_delta(direction)

      distance.times do
        num = (num + delta) % 100
        zeros += 1 if num == 0
      end
    end

    zeros
  end
end
