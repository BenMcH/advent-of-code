require "minitest/autorun"

require_relative "./day_16"
require_relative "./helpers"

class Day16Test < Minitest::Test
  def self.test_order; :alpha; end # Stable test order for readability

  def setup
    @test_input = <<~INPUT
      ###############
      #.......#....E#
      #.#.###.#.###.#
      #.....#.#...#.#
      #.###.#####.#.#
      #.#.#.......#.#
      #.#.#####.###.#
      #...........#.#
      ###.#.#####.#.#
      #...#.....#.#.#
      #.#.#.###.#.#.#
      #.....#...#.#.#
      #.###.#.#.#.#.#
      #S..#.....#...#
      ###############
    INPUT

    @test_input = @test_input.strip

    @input = AdventOfCodeHelpers.get_input(16)
  end

  def test_part_1
    assert_equal 7036, Day16.part_1(@test_input)

    answer = Day16.part_1(@input)
    puts "Part 1: #{answer}"

    AdventOfCodeHelpers.submit_answer(16, answer, 1)
  end

  def test_part_2
    skip("Part 2 not yet implemented")
    assert_equal 1, Day16.part_2(@test_input)

    answer = Day16.part_2(@input)
    puts "Part 2: #{answer}"

    AdventOfCodeHelpers.submit_answer(16, answer, 2)
  end
end
