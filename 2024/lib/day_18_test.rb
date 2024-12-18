require "minitest/autorun"

require_relative "./day_18"
require_relative "./helpers"

class Day18Test < Minitest::Test
  def self.test_order; :alpha; end # Stable test order for readability

  def setup
    @test_input = <<~INPUT
    5,4
    4,2
    4,5
    3,0
    2,1
    6,3
    2,4
    1,5
    0,6
    3,3
    2,6
    5,1
    1,2
    5,5
    2,5
    6,5
    1,4
    0,4
    6,4
    1,1
    6,1
    1,0
    0,5
    1,6
    2,0
    INPUT

    @test_input = @test_input.strip

    @input = AdventOfCodeHelpers.get_input(18)
  end

  def test_part_1
    assert_equal 22, Day18.part_1(@test_input, 6, 12)

    answer = Day18.part_1(@input)
    puts "Part 1: #{answer}"

    AdventOfCodeHelpers.submit_answer(18, answer, 1)
  end

  def test_part_2
    assert_equal "6,1", Day18.part_2(@test_input, 6, 12)

    answer = Day18.part_2(@input)
    puts "Part 2: #{answer}"

    AdventOfCodeHelpers.submit_answer(18, answer, 2)
  end
end
