require_relative "./helpers"

class Day07
  def self.parse(input)
    input.strip.split("\n").map do |line|
      AdventOfCodeHelpers.get_numbers line
    end
  end

  def self.can_solve(target, numbers, part_2 = false)
    if numbers.length == 1
      return numbers[0] == target
    end

    first, second, *rest = numbers

    return false if first > target

    nums = [
      first + second,
      first * second,
    ]

    if part_2
      nums << "#{first}#{second}".to_i
    end

    return nums.any? { |num| can_solve(target, [num] + rest, part_2) }
  end

  def self.part_1(input)
    input = parse input

    return input.filter { |line| can_solve(line[0], line[1..]) }.map(&:first).sum
  end

  def self.part_2(input)
    input = parse input

    return input.filter { |line| can_solve(line[0], line[1..], true) }.map(&:first).sum
  end
end
