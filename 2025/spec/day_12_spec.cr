require "spec"

require "../src/day_12"
require "../helpers"

test_input = "".strip
input = AdventOfCodeHelpers.get_input(12)

describe "Day 12" do
  describe "Part 1" do
    it "should pass the test input" do
      # test_input = test_input.strip

      # Day12.part_1(test_input).should eq(1)

      answer = Day12.part_1(input)
      puts "Part 1: #{answer}"
      # AdventOfCodeHelpers.submit_answer(12, answer.to_s, 1)
    end
  end

  describe "Part 2" do
    it "should pass the test input", tags: "skip" do
      test_input = "
            "
      test_input = test_input.strip

      Day12.part_2(test_input).should eq(1)

      answer = Day12.part_2(input)
      puts "Part 2: #{answer}"
      AdventOfCodeHelpers.submit_answer(12, answer.to_s, 2)
    end
  end
end
