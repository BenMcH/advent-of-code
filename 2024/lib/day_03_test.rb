require "minitest/autorun"

require_relative "./day_03"
require_relative "./helpers"

class Day3Test < Minitest::Test
  def setup
    @test_input = <<~INPUT
      xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
    INPUT

    @test_input = @test_input.strip

    @input = AdventOfCodeHelpers.get_input(3)
  end

  def test_part_1
    assert_equal 161, Day03.part_1(@test_input)

    puts "Part 1: #{Day03.part_1(@input)}"
  end

  def test_part_2
    assert_equal 48, Day03.part_2("xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))")

    puts "Part 2: #{Day03.part_2(@input)}"
  end
end
