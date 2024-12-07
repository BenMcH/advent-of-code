require_relative "./helpers"

class Day07
  def self.parse(input)
    input.strip.split("\n").map do |line|
      AdventOfCodeHelpers.get_numbers line
    end
  end

  def self.can_solve(target, numbers, part_2 = false)
    if numbers.length == 0
      return target == 0
    end

    first, *rest = numbers

    return false if first > target || target < 0

    nums = []

    if target >= first
      return true if can_solve(target - first, rest, part_2)
    end

    if target % first == 0
      return true if can_solve(target / first, rest, part_2)
    end

    if part_2
      t_str = target.to_s

      if t_str.end_with?(first.to_s)
        t_str = t_str.delete_suffix(first.to_s)
        return true if can_solve(t_str.to_i, rest, part_2)
      end
    end

    return false
  end

  def self.part_1(input)
    input = parse input

    return input.filter { |line| can_solve(line[0], line[1..].reverse) }.map(&:first).sum
  end

  def self.part_2(input)
    input = parse input

    return input.filter { |line| can_solve(line[0], line[1..].reverse, true) }.map(&:first).sum
  end
end
