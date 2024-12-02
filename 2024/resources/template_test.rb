require 'minitest/autorun'

require_relative './day_ZPDAY'
require_relative './helpers'

class DayDAYTest < Minitest::Test
  def setup
    @test_input = <<~INPUT
    INPUT

    @test_input = @test_input.strip

    @input = AdventOfCodeHelpers.get_input(DAY)
  end

  def test_part_1
    assert_equal 1, DayZPDAY.part_1(@test_input)
    
    puts "Part 1: #{DayZPDAY.part_1(@input)}"
  end

  def test_part_2
    assert_equal 1, DayZPDAY.part_2(@test_input)

    puts "Part 2: #{DayZPDAY.part_2(@input)}"
  end
end
