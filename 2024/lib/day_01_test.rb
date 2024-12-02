require 'minitest/autorun'

require_relative './day_01'
require_relative './helpers'

class Day1Test < Minitest::Test
  def setup
    @test_input = <<-INPUT
      3   4
      4   3
      2   5
      1   3
      3   9
      3   3
    INPUT
    
    @test_input = @test_input.strip
    
    @input = AdventOfCodeHelpers.get_input(1)
  end

  def test_part_1
    assert_equal 11, Day01.part_1(@test_input)
    puts "Part 1: #{Day01.part_1(@input)}"
  end

  def test_part_2
    assert_equal 31, Day01.part_2(@test_input)

    puts "Part 2: #{Day01.part_2(@input)}"
  end
end
