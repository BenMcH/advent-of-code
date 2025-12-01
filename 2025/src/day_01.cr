class Day01
  def self.part_1(input : String) : Int32
    num = 50

    lines = input.lines.map(&.strip).reject(&.empty?)

    zeros = 0

    lines.each do |line|
      direction = line[0]
      distance = line[1..].to_i

      case direction
      when 'L'
        num -= distance
      when 'R'
        num += distance
      end

      num = num % 100

      if num == 0
        zeros += 1
      end
    end

    zeros
  end

  def self.part_2(input : String) : Int32
    num = 50

    lines = input.lines.map(&.strip).reject(&.empty?)

    zeros = 0

    lines.each do |line|
      direction = line[0]
      distance = line[1..].to_i

      case direction
      when 'L'
        while distance > 0
          num -= 1
          distance -= 1

          if num % 100 == 0
            zeros += 1
          end
        end
      when 'R'
        while distance > 0
          num += 1
          distance -= 1

          if num % 100 == 0
            zeros += 1
          end
        end
      end

      num = num % 100
    end

    zeros
  end
end
