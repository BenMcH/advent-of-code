require "minitest/autorun"

require_relative "./day_08"
require_relative "./helpers"

class Day8Test < Minitest::Test
  def self.test_order; :alpha; end # Stable test order for readability

  def setup
    @test_input = <<~INPUT
      2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2
    INPUT

    @test_input = @test_input.strip

    @input = AdventOfCodeHelpers.get_input(8)
  end

  def test_part_1
    assert_equal 138, Day08.part_1(@test_input)

    answer = Day08.part_1(@input)
    puts "Part 1: #{answer}"

    AdventOfCodeHelpers.submit_answer(8, answer, 1)
  end

  def test_part_2
    assert_equal 66, Day08.part_2(@test_input)

    answer = Day08.part_2(@input)
    puts "Part 2: #{answer}"

    AdventOfCodeHelpers.submit_answer(8, answer, 2)
  end
end
