require "minitest/autorun"

require_relative "./day_09"
require_relative "./helpers"

class Day9Test < Minitest::Test
  def self.test_order; :alpha; end # Stable test order for readability

  def setup
    @test_input = <<~INPUT
      2333133121414131402
    INPUT

    @test_input = @test_input.strip

    @input = AdventOfCodeHelpers.get_input(9)
  end

  def test_part_1
    assert_equal 1928, Day09.part_1(@test_input)

    answer = Day09.part_1(@input)
    puts "Part 1: #{answer}"

    AdventOfCodeHelpers.submit_answer(9, answer, 1)
  end

  def test_part_2
    skip("Part 2 not yet implemented")
    assert_equal 1, Day09.part_2(@test_input)

    answer = Day09.part_2(@input)
    puts "Part 2: #{answer}"

    AdventOfCodeHelpers.submit_answer(9, answer, 2)
  end
end
