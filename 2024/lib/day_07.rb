require_relative "./helpers"

class Day07
  def self.parse(input)
    input.strip.split("\n").map do |line|
      AdventOfCodeHelpers.get_numbers line
    end
  end

  def self.can_solve(target, numbers)
    if numbers.length == 1
      return numbers[0] == target
    end

    first, second, *rest = numbers

    return can_solve(target, [first + second, *rest]) || can_solve(target, [first * second, *rest])
  end

  def self.part_1(input)
    input = parse input

    return input.filter { |line| can_solve(line[0], line[1..]) }.map(&:first).sum
  end

  def self.part_2(input)
    return 0
  end
end
