require "minitest/autorun"

require_relative "./day_04"
require_relative "./helpers"

class Day4Test < Minitest::Test
  def setup
    @test_input = <<~INPUT
      MMMSXXMASM
      MSAMXMSMSA
      AMXSXMAAMM
      MSAMASMSMX
      XMASAMXAMM
      XXAMMXXAMA
      SMSMSASXSS
      SAXAMASAAA
      MAMMMXMMMM
      MXMXAXMASX
    INPUT

    @test_input = @test_input.strip

    @input = AdventOfCodeHelpers.get_input(4)
  end

  def test_part_1
    assert_equal 18, Day04.part_1(@test_input)

    puts "Part 1: #{Day04.part_1(@input)}"
  end

  def test_part_2
    assert_equal 9, Day04.part_2(@test_input)

    puts "Part 2: #{Day04.part_2(@input)}"
  end
end
