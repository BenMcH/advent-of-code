require "minitest/autorun"

require_relative "./day_07"
require_relative "./helpers"

class Day7Test < Minitest::Test
  def self.test_order; :alpha; end # Stable test order for readability

  def setup
    @test_input = <<~INPUT
      Step C must be finished before step A can begin.
      Step C must be finished before step F can begin.
      Step A must be finished before step B can begin.
      Step A must be finished before step D can begin.
      Step B must be finished before step E can begin.
      Step D must be finished before step E can begin.
      Step F must be finished before step E can begin.
    INPUT

    @test_input = @test_input.strip

    @input = AdventOfCodeHelpers.get_input(7)
  end

  def test_part_1
    assert_equal "CABDFE", Day07.part_1(@test_input)

    answer = Day07.part_1(@input)
    puts "Part 1: #{answer}"

    AdventOfCodeHelpers.submit_answer(7, answer, 1)
  end

  def test_part_2
    assert_equal 15, Day07.part_2(@test_input, 2, 0)

    answer = Day07.part_2(@input)
    puts "Part 2: #{answer}"

    AdventOfCodeHelpers.submit_answer(7, answer, 2)
  end
end
