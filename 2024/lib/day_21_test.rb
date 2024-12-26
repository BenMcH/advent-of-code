require "minitest/autorun"

require_relative "./day_21"
require_relative "./helpers"

class Day21Test < Minitest::Test
  def self.test_order; :alpha; end # Stable test order for readability

  def setup
    @test_input = <<~INPUT
      029A
      980A
      179A
      456A
      379A
    INPUT

    @test_input = @test_input.strip

    @input = AdventOfCodeHelpers.get_input(21)
  end

  def test_part_1
    assert_equal 126384, Day21.part_1(@test_input)

    answer = Day21.part_1(@input)
    puts "Part 1: #{answer}"

    AdventOfCodeHelpers.submit_answer(21, answer, 1)
  end

  def test_part_2
    skip("Part 2 not yet implemented")
    assert_equal 1, Day21.part_2(@test_input)

    answer = Day21.part_2(@input)
    puts "Part 2: #{answer}"

    AdventOfCodeHelpers.submit_answer(21, answer, 2)
  end
end
