require "spec"

require "../src/day_09"
require "../helpers"

test_input = "7,1
11,1
11,7
9,7
9,5
2,5
2,3
7,3".strip
input = AdventOfCodeHelpers.get_input(9)

describe "Day 9" do
  describe "Part 1" do
    it "should pass the test input" do
      test_input = test_input.strip

      Day09.part_1(test_input).should eq(50)

      answer = Day09.part_1(input)
      puts "Part 1: #{answer}"
      AdventOfCodeHelpers.submit_answer(9, answer.to_s, 1)
    end
  end

  describe "Part 2" do
    it "should pass the test input" do
      Day09.part_2(test_input).should eq(24)

      answer = Day09.part_2(input)
      puts "Part 2: #{answer}"
      AdventOfCodeHelpers.submit_answer(9, answer.to_s, 2)
    end
  end
end
