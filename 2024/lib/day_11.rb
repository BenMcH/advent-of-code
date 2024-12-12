class Day11
  def self.blink(input, n)
    stones = Hash.new(0)

    input.each do |stone|
      stones[stone] += 1
    end

    n.times do
      n_stones = Hash.new(0)
      stones.each do |stone, count|
        if stone == 0
          n_stones[1] += count
        elsif "#{stone}".length.even?
          str = "#{stone}"
          first_half, second_half = str[0..(str.length / 2 - 1)], str[(str.length / 2)..]

          n_stones[first_half.to_i] += count
          n_stones[second_half.to_i] += count
        else
          n_stones[stone * 2024] += count
        end
      end
      stones = n_stones
    end

    stones.values.sum
  end

  def self.part_1(input)
    input = input.scan(/\d+/).map(&:to_i)

    return blink(input, 25)
  end

  def self.part_2(input)
    input = input.scan(/\d+/).map(&:to_i)
    blink(input, 75)
  end
end
