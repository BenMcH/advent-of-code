require "minitest/autorun"

require_relative "./day_11"
require_relative "./helpers"

class Day11Test < Minitest::Test
  def self.test_order; :alpha; end # Stable test order for readability

  def setup
    @test_input = "42"

    @input = AdventOfCodeHelpers.get_input(11)
  end

  def test_part_1
    assert_equal "21,61", Day11.part_1(@test_input)

    answer = Day11.part_1(@input)
    puts "Part 1: #{answer}"

    AdventOfCodeHelpers.submit_answer(11, answer, 1)
  end

  def test_part_2
    assert_equal "232,251,12", Day11.part_2(@test_input)

    answer = Day11.part_2(@input)
    puts "Part 2: #{answer}"

    AdventOfCodeHelpers.submit_answer(11, answer, 2)
  end
end
