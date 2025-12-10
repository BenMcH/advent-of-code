require "spec"

require "../src/day_10"
require "../helpers"

test_input = "[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}".strip
input = AdventOfCodeHelpers.get_input(10)

describe "Day 10" do
  describe "Part 1" do
    it "should pass the test input" do
      test_input = test_input.strip

      Day10.part_1(test_input).should eq(7)

      answer = Day10.part_1(input)
      puts "Part 1: #{answer}"
      AdventOfCodeHelpers.submit_answer(10, answer.to_s, 1)
    end
  end

  describe "Part 2" do
    it "should pass the test input", tags: "skip" do
      test_input = "
            "
      test_input = test_input.strip

      Day10.part_2(test_input).should eq(1)

      answer = Day10.part_2(input)
      puts "Part 2: #{answer}"
      AdventOfCodeHelpers.submit_answer(10, answer.to_s, 2)
    end
  end
end
