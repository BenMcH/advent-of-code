require "minitest/autorun"

require_relative "./day_17"
require_relative "./helpers"

class Day17Test < Minitest::Test
  def self.test_order; :alpha; end # Stable test order for readability

  def setup
    @test_input = <<~INPUT
      Register A: 729
      Register B: 0
      Register C: 0

      Program: 0,1,5,4,3,0
    INPUT

    @test_input = @test_input.strip

    @input = AdventOfCodeHelpers.get_input(17)
  end

  def test_part_1
    assert_equal "4,6,3,5,6,3,5,2,1,0", Day17.part_1(@test_input)

    answer = Day17.part_1(@input)
    puts "Part 1: #{answer}"

    AdventOfCodeHelpers.submit_answer(17, answer, 1)
  end

  def test_part_2
    skip("Part 2 not yet implemented")
    assert_equal 1, Day17.part_2(@test_input)

    answer = Day17.part_2(@input)
    puts "Part 2: #{answer}"

    AdventOfCodeHelpers.submit_answer(17, answer, 2)
  end
end
