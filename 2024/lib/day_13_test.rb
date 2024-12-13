require "minitest/autorun"

require_relative "./day_13"
require_relative "./helpers"

class Day13Test < Minitest::Test
  def self.test_order; :alpha; end # Stable test order for readability

  def setup
    @test_input = <<~INPUT
      Button A: X+94, Y+34
      Button B: X+22, Y+67
      Prize: X=8400, Y=5400

      Button A: X+26, Y+66
      Button B: X+67, Y+21
      Prize: X=12748, Y=12176

      Button A: X+17, Y+86
      Button B: X+84, Y+37
      Prize: X=7870, Y=6450

      Button A: X+69, Y+23
      Button B: X+27, Y+71
      Prize: X=18641, Y=10279
    INPUT

    @test_input = @test_input.strip

    @input = AdventOfCodeHelpers.get_input(13)
  end

  def test_part_1
    assert_equal 480, Day13.part_1(@test_input)

    answer = Day13.part_1(@input)
    puts "Part 1: #{answer}"

    AdventOfCodeHelpers.submit_answer(13, answer, 1)
  end

  def test_part_2
    answer = Day13.part_2(@input)
    puts "Part 2: #{answer}"

    AdventOfCodeHelpers.submit_answer(13, answer, 2)
  end
end
