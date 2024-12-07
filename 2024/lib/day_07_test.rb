require "minitest/autorun"

require_relative "./day_07"
require_relative "./helpers"

class Day7Test < Minitest::Test
  def self.test_order; :alpha; end # Stable test order for readability

  def setup
    @test_input = <<~INPUT
      190: 10 19
      3267: 81 40 27
      83: 17 5
      156: 15 6
      7290: 6 8 6 15
      161011: 16 10 13
      192: 17 8 14
      21037: 9 7 18 13
      292: 11 6 16 20
    INPUT

    @test_input = @test_input.strip

    @input = AdventOfCodeHelpers.get_input(7)
  end

  def test_part_1
    assert_equal 3749, Day07.part_1(@test_input)

    answer = Day07.part_1(@input)
    puts "Part 1: #{answer}"

    AdventOfCodeHelpers.submit_answer(7, answer, 1)
  end

  def test_part_2
    skip("Part 2 not yet implemented")
    assert_equal 1, Day07.part_2(@test_input)

    answer = Day07.part_2(@input)
    puts "Part 2: #{answer}"

    AdventOfCodeHelpers.submit_answer(7, answer, 2)
  end
end
