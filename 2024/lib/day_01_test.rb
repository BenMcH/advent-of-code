require 'minitest/autorun'

require_relative './day_01'
require_relative './helpers'

@test_input = <<~INPUT
INPUT

@test_input = @test_input.strip

@input = AdventOfCodeHelpers.get_input(1)


class Day1Test < Minitest::Test
  def test_part_1
    assert_equal 1, Day01.part_1(@test_input)
    
    puts "Part 1: #{Day01.part_1(@input)}"
  end

  def test_part_2
    skip("Not implemented")
    assert_equal 1, Day01.part_2(@test_input)

    puts "Part 2: #{Day01.part_2(@input)}"
  end
end
