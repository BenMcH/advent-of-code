require "spec"

require "../src/day_01"
require "../helpers"

test_input = "L68
L30
R48
L5
R60
L55
L1
L99
R14
L82".strip
input = AdventOfCodeHelpers.get_input(1)

describe "Day 1" do
  describe "Part 1" do
    it "should pass the test input" do
      test_input = test_input.strip

      Day01.part_1(test_input).should eq(3)

      answer = Day01.part_1(input)
      puts "Part 1: #{answer}"
      AdventOfCodeHelpers.submit_answer(1, answer.to_s, 1)
    end
  end

  describe "Part 2" do
    it "should pass the test input" do
      test_input = test_input.strip

      Day01.part_2(test_input).should eq(6)

      answer = Day01.part_2(input)
      puts "Part 2: #{answer}"
      AdventOfCodeHelpers.submit_answer(1, answer.to_s, 2)
    end
  end
end
