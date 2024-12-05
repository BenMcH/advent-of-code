require "minitest/autorun"

require_relative "./day_02"
require_relative "./helpers"

class Day2Test < Minitest::Test
  def setup
    @test_input = <<~INPUT
      7 6 4 2 1
      1 2 7 8 9
      9 7 6 2 1
      1 3 2 4 5
      8 6 4 4 1
      1 3 6 7 9
    INPUT

    @test_input = @test_input.strip

    @input = AdventOfCodeHelpers.get_input(2)
  end

  def test_part_1
    assert_equal 2, Day02.part_1(@test_input)

    puts "Part 1: #{Day02.part_1(@input)}"
  end

  def test_part_2
    assert_equal 4, Day02.part_2(@test_input)

    puts "Part 2: #{Day02.part_2(@input)}"
  end
end
