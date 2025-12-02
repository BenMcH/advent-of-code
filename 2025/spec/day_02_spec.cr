require "spec"

require "../src/day_02"
require "../helpers"

test_input = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124".strip
input = AdventOfCodeHelpers.get_input(2)

describe "Day 2" do
  describe "Part 1" do
    it "should pass the test input" do
      test_input = test_input.strip

      Day02.part_1(test_input).should eq(1227775554)

      answer = Day02.part_1(input)
      puts "Part 1: #{answer}"
      AdventOfCodeHelpers.submit_answer(2, answer.to_s, 1)
    end
  end

  describe "Part 2" do
    it "should pass the test input" do
      Day02.part_2(test_input).should eq(4174379265)

      answer = Day02.part_2(input)
      puts "Part 2: #{answer}"
      AdventOfCodeHelpers.submit_answer(2, answer.to_s, 2)
    end
  end
end
