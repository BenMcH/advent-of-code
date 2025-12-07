require "spec"

require "../src/day_07"
require "../helpers"

test_input = ".......S.......
...............
.......^.......
...............
......^.^......
...............
.....^.^.^.....
...............
....^.^...^....
...............
...^.^...^.^...
...............
..^...^.....^..
...............
.^.^.^.^.^...^.
...............".strip
input = AdventOfCodeHelpers.get_input(7)

describe "Day 7" do
  describe "Part 1" do
    it "should pass the test input" do
      test_input = test_input.strip

      Day07.part_1(test_input).should eq(21)

      answer = Day07.part_1(input)
      puts "Part 1: #{answer}"
      AdventOfCodeHelpers.submit_answer(7, answer.to_s, 1)
    end
  end

  describe "Part 2" do
    it "should pass the test input" do
      Day07.part_2(test_input).should eq(40)
      answer = Day07.part_2(input)
      puts "Part 2: #{answer}"
      AdventOfCodeHelpers.submit_answer(7, answer.to_s, 2)
    end
  end
end
