require "spec"

require "../src/day_06"
require "../helpers"

test_input = "123 328  51 64
 45 64  387 23
  6 98  215 314
*   +   *   +  "
input = AdventOfCodeHelpers.get_input(6)

describe "Day 6" do
  describe "Part 1" do
    it "should pass the test input" do
      Day06.part_1(test_input).should eq(4277556)

      answer = Day06.part_1(input)
      puts "Part 1: #{answer}"
      AdventOfCodeHelpers.submit_answer(6, answer.to_s, 1)
    end
  end

  describe "Part 2" do
    it "should pass the test input" do
      Day06.part_2(test_input).should eq(3263827)

      answer = Day06.part_2(input)
      puts "Part 2: #{answer}"
      AdventOfCodeHelpers.submit_answer(6, answer.to_s, 2)
    end
  end
end
