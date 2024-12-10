require "minitest/autorun"

require_relative "./day_10"
require_relative "./helpers"

class Day10Test < Minitest::Test
  def self.test_order; :alpha; end # Stable test order for readability

  def setup
    @test_input = <<~INPUT
      89010123
      78121874
      87430965
      96549874
      45678903
      32019012
      01329801
      10456732
    INPUT

    @test_input = @test_input.strip

    @input = AdventOfCodeHelpers.get_input(10)
  end

  def test_part_1
    assert_equal 36, Day10.part_1(@test_input)

    answer = Day10.part_1(@input)
    puts "Part 1: #{answer}"

    AdventOfCodeHelpers.submit_answer(10, answer, 1)
  end

  def test_part_2
    assert_equal 81, Day10.part_2(@test_input)

    answer = Day10.part_2(@input)
    puts "Part 2: #{answer}"

    AdventOfCodeHelpers.submit_answer(10, answer, 2)
  end
end
