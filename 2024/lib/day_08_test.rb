require "minitest/autorun"

require_relative "./day_08"
require_relative "./helpers"

class Day8Test < Minitest::Test
  def self.test_order; :alpha; end # Stable test order for readability

  def setup
    @test_input = <<~INPUT
      ............
      ........0...
      .....0......
      .......0....
      ....0.......
      ......A.....
      ............
      ............
      ........A...
      .........A..
      ............
      ............
    INPUT

    @test_input = @test_input.strip

    @input = AdventOfCodeHelpers.get_input(8)
  end

  def test_make_antinodes
    test_input = <<~INPUT
      ..........
      ..........
      ..........
      ....a.....
      ..........
      .....a....
      ..........
      ..........
      ..........
      ..........
    INPUT
    input, nodes = Day08.parse(test_input)

    nodes = nodes["a"]

    nodes = Day08.make_antinodes([[1, 1], [2, 2]])

    assert nodes.is_a?(Array)
    assert_equal 2, nodes.length
    assert nodes.include?([0, 0])
    assert nodes.include?([3, 3])
  end

  def test_part_1
    assert_equal 14, Day08.part_1(@test_input)

    answer = Day08.part_1(@input)
    puts "Part 1: #{answer}"

    AdventOfCodeHelpers.submit_answer(8, answer, 1)
  end

  def test_part_2
    assert_equal 34, Day08.part_2(@test_input)

    answer = Day08.part_2(@input)
    puts "Part 2: #{answer}"

    AdventOfCodeHelpers.submit_answer(8, answer, 2)
  end
end
