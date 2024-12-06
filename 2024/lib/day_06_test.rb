require "minitest/autorun"

require_relative "./day_06"
require_relative "./helpers"

class Day6Test < Minitest::Test
  def self.test_order; :alpha; end # Stable test order for readability

  def setup
    @test_input = <<~INPUT
      ....#.....
      .........#
      ..........
      ..#.......
      .......#..
      ..........
      .#..^.....
      ........#.
      #.........
      ......#...
    INPUT

    @test_input = @test_input.strip

    @input = AdventOfCodeHelpers.get_input(6)
  end

  def test_part_1
    assert_equal 41, Day06.part_1(@test_input)

    answer = Day06.part_1(@input)
    puts "Part 1: #{answer}"

    AdventOfCodeHelpers.submit_answer(6, answer, 1)
  end

  def test_part_2
    assert_equal 6, Day06.part_2(@test_input)
    print("Here")

    answer = Day06.part_2(@input)
    puts "Part 2: #{answer}"

    AdventOfCodeHelpers.submit_answer(6, answer, 2)
  end
end
