require "minitest/autorun"

require_relative "./day_14"
require_relative "./helpers"

class Day14Test < Minitest::Test
  def self.test_order; :alpha; end # Stable test order for readability

  def setup
    @test_input = <<~INPUT
    2018
    INPUT

    @test_input = @test_input.strip

    @input = AdventOfCodeHelpers.get_input(14)
  end

  def test_part_1
    assert_equal "5941429882", Day14.part_1(@test_input)

    answer = Day14.part_1(@input)
    puts "Part 1: #{answer}"

    AdventOfCodeHelpers.submit_answer(14, answer, 1)
  end

  def test_part_2
    assert_equal 2018, Day14.part_2("59414")

    answer = Day14.part_2(@input)
    puts "Part 2: #{answer}"

    AdventOfCodeHelpers.submit_answer(14, answer, 2)
  end
end
