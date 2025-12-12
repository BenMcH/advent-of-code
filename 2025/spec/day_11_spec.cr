require "spec"

require "../src/day_11"
require "../helpers"

test_input = "aaa: you hhh
you: bbb ccc
bbb: ddd eee
ccc: ddd eee fff
ddd: ggg
eee: out
fff: out
ggg: out
hhh: ccc fff iii
iii: out".strip
input = AdventOfCodeHelpers.get_input(11)

describe "Day 11" do
  describe "Part 1" do
    it "should pass the test input" do
      test_input = test_input.strip

      Day11.part_1(test_input).should eq(5)

      answer = Day11.part_1(input)
      puts "Part 1: #{answer}"
      AdventOfCodeHelpers.submit_answer(11, answer.to_s, 1)
    end
  end

  describe "Part 2" do
    it "should pass the test input", tags: "skip" do
      test_input = test_input.strip

      Day11.part_2(test_input).should eq(1)

      answer = Day11.part_2(input)
      puts "Part 2: #{answer}"
      AdventOfCodeHelpers.submit_answer(11, answer.to_s, 2)
    end
  end
end
