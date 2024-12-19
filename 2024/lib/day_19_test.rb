require "minitest/autorun"

require_relative "./day_19"
require_relative "./helpers"

class Day19Test < Minitest::Test
  def self.test_order; :alpha; end # Stable test order for readability

  def setup
    @test_input = <<~INPUT
      r, wr, b, g, bwu, rb, gb, br

      brwrr
      bggr
      gbbr
      rrbgbr
      ubwu
      bwurrg
      brgr
      bbrgwb
    INPUT

    @test_input = @test_input.strip

    @input = AdventOfCodeHelpers.get_input(19)
  end

  def test_part_1
    assert_equal 6, Day19.part_1(@test_input)

    answer = Day19.part_1(@input)
    puts "Part 1: #{answer}"

    AdventOfCodeHelpers.submit_answer(19, answer, 1)
  end

  def test_part_2
    assert_equal 16, Day19.part_2(@test_input)

    answer = Day19.part_2(@input)
    puts "Part 2: #{answer}"

    AdventOfCodeHelpers.submit_answer(19, answer, 2)
  end
end
