require "minitest/autorun"

require_relative "./day_20"
require_relative "./helpers"

class Day20Test < Minitest::Test
  def self.test_order; :alpha; end # Stable test order for readability

  def setup
    @test_input = <<~INPUT
      ###############
      #...#...#.....#
      #.#.#.#.#.###.#
      #S#...#.#.#...#
      #######.#.#.###
      #######.#.#...#
      #######.#.###.#
      ###..E#...#...#
      ###.#######.###
      #...###...#...#
      #.#####.#.###.#
      #.#...#.#.#...#
      #.#.#.#.#.#.###
      #...#...#...###
      ###############
    INPUT

    @test_input = @test_input.strip

    @input = AdventOfCodeHelpers.get_input(20)
  end

  def test_part_1
    assert_equal 1, Day20.part_1(@test_input, 64)

    answer = Day20.part_1(@input)
    puts "Part 1: #{answer}"

    AdventOfCodeHelpers.submit_answer(20, answer, 1)
  end

  def test_part_2
    assert_equal 3, Day20.part_2(@test_input, 76)

    answer = Day20.part_2(@input)
    puts "Part 2: #{answer}"

    AdventOfCodeHelpers.submit_answer(20, answer, 2)
  end
end
