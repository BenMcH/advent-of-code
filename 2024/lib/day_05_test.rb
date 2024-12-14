require "minitest/autorun"

require_relative "./day_05"
require_relative "./helpers"

class Day5Test < Minitest::Test
  def self.test_order; :alpha; end # Stable test order for readability

  def setup
    @test_input = <<~INPUT
      47|53
      97|13
      97|61
      97|47
      75|29
      61|13
      75|53
      29|13
      97|29
      53|29
      61|53
      97|53
      61|29
      47|13
      75|47
      97|75
      47|61
      75|61
      47|29
      75|13
      53|13

      75,47,61,53,29
      97,61,53,29,13
      75,29,13
      75,97,47,61,53
      61,13,29
      97,13,75,29,47
    INPUT

    @test_input = @test_input.strip

    @input = AdventOfCodeHelpers.get_input(5)
  end

  def test_part_1
    assert_equal 143, Day05.part_1(@test_input)

    answer = Day05.part_1(@input)
    puts "Part 1: #{answer}"

    AdventOfCodeHelpers.submit_answer(5, answer, 1)
  end

  def test_part_2
    assert_equal 123, Day05.part_2(@test_input)

    answer = Day05.part_2(@input)
    puts "Part 2: #{answer}"

    AdventOfCodeHelpers.submit_answer(5, answer, 2)
  end
end
