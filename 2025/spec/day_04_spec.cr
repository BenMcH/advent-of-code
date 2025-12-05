require "spec"

require "../src/day_04"
require "../helpers"

test_input = "..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@.".strip
input = AdventOfCodeHelpers.get_input(4)

describe "Day 4" do
  describe "Part 1" do
    it "should pass the test input" do
      test_input = test_input.strip

      Day04.part_1(test_input).should eq(13)

      answer = Day04.part_1(input)
      puts "Part 1: #{answer}"
      AdventOfCodeHelpers.submit_answer(4, answer.to_s, 1)
    end
  end

  describe "Part 2" do
    it "should pass the test input" do
      test_input = test_input.strip

      Day04.part_2(test_input).should eq(43)

      answer = Day04.part_2(input)
      puts "Part 2: #{answer}"
      AdventOfCodeHelpers.submit_answer(4, answer.to_s, 2)
    end
  end
end
