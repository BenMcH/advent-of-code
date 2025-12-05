require "spec"

require "../src/day_05"
require "../helpers"

test_input = "3-5
10-14
16-20
12-18

1
5
8
11
17
32".strip
input = AdventOfCodeHelpers.get_input(5)

describe "Day 5" do
  describe "Part 1" do
    it "should pass the test input" do
      test_input = test_input.strip

      Day05.part_1(test_input).should eq(3)

      answer = Day05.part_1(input)
      puts "Part 1: #{answer}"
      AdventOfCodeHelpers.submit_answer(5, answer.to_s, 1)
    end
  end

  describe "Part 2" do
    it "should pass the test input" do
      test_input = test_input.strip

      Day05.part_2(test_input).should eq(14)

      answer = Day05.part_2(input)
      puts "Part 2: #{answer}"
      AdventOfCodeHelpers.submit_answer(5, answer.to_s, 2)
    end
  end
end
