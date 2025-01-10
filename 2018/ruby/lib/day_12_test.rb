require "minitest/autorun"

require_relative "./day_12"
require_relative "./helpers"

class Day12Test < Minitest::Test
  def self.test_order; :alpha; end # Stable test order for readability

  def setup
    @test_input = <<~INPUT
      initial state: #..#.#..##......###...###

      ...## => #
      ..#.. => #
      .#... => #
      .#.#. => #
      .#.## => #
      .##.. => #
      .#### => #
      #.#.# => #
      #.### => #
      ##.#. => #
      ##.## => #
      ###.. => #
      ###.# => #
      ####. => #
    INPUT

    @test_input = @test_input.strip

    @input = AdventOfCodeHelpers.get_input(12)
  end

  def test_part_1
    #assert_equal 325, Day12.part_1(@test_input)

    answer = Day12.part_1(@input)
    puts "Part 1: #{answer}"

    AdventOfCodeHelpers.submit_answer(12, answer, 1)
  end

  def test_part_2
    answer = Day12.part_2(@input)
    puts "Part 2: #{answer}"

    AdventOfCodeHelpers.submit_answer(12, answer, 2)
  end
end
