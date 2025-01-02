require "minitest/autorun"

require_relative "./day_05"
require_relative "./helpers"

class Day5Test < Minitest::Test
  def self.test_order; :alpha; end # Stable test order for readability

  def setup
    @test_input = <<~INPUT
      dabAcCaCBAcCcaDA
    INPUT

    @test_input = @test_input.strip

    @input = AdventOfCodeHelpers.get_input(5)
  end

  def test_part_1
    assert_equal 10, Day05.part_1(@test_input)

    answer = Day05.part_1(@input)
    puts "Part 1: #{answer}"

    AdventOfCodeHelpers.submit_answer(5, answer, 1)
  end

  def test_part_2
    assert_equal 4, Day05.part_2(@test_input)

    answer = Day05.part_2(@input)
    puts "Part 2: #{answer}"

    AdventOfCodeHelpers.submit_answer(5, answer, 2)
  end
end
