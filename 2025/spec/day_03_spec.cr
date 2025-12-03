require "spec"

require "../src/day_03"
require "../helpers"

test_input = "987654321111111
811111111111119
234234234234278
818181911112111".strip
input = AdventOfCodeHelpers.get_input(3)

describe "Day 3" do
  describe "Part 1" do
    it "should pass the test input" do
      test_input = test_input.strip

      Day03.part_1(test_input).should eq(357)

      answer = Day03.part_1(input)
      puts "Part 1: #{answer}"
      AdventOfCodeHelpers.submit_answer(3, answer.to_s, 1)
    end
  end

  describe "Part 2" do
    it "should pass the test input" do
      Day03.part_2(test_input).should eq(3121910778619)

      answer = Day03.part_2(input)
      puts "Part 2: #{answer}"
      AdventOfCodeHelpers.submit_answer(3, answer.to_s, 2)
    end
  end
end
