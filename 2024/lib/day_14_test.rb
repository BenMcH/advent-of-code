require "minitest/autorun"

require_relative "./day_14"
require_relative "./helpers"

class Day14Test < Minitest::Test
  def self.test_order; :alpha; end # Stable test order for readability

  def setup
    @test_input = <<~INPUT
      p=0,4 v=3,-3
      p=6,3 v=-1,-3
      p=10,3 v=-1,2
      p=2,0 v=2,-1
      p=0,0 v=1,3
      p=3,0 v=-2,-2
      p=7,6 v=-1,-3
      p=3,0 v=-1,-2
      p=9,3 v=2,3
      p=7,3 v=-1,2
      p=2,4 v=2,-3
      p=9,5 v=-3,-3
    INPUT

    @test_input = @test_input.strip

    @input = AdventOfCodeHelpers.get_input(14)
  end

  def test_part_1
    assert_equal 12, Day14.part_1(@test_input, 11, 7)

    answer = Day14.part_1(@input)
    puts "Part 1: #{answer}"

    AdventOfCodeHelpers.submit_answer(14, answer, 1)
  end

  def test_part_2
    puts "Part 2: #{Day14.part_2(@input)}"
  end
end
