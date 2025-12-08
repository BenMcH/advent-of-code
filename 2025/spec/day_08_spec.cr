require "spec"

require "../src/day_08"
require "../helpers"

test_input = "162,817,812
57,618,57
906,360,560
592,479,940
352,342,300
466,668,158
542,29,236
431,825,988
739,650,466
52,470,668
216,146,977
819,987,18
117,168,530
805,96,715
346,949,466
970,615,88
941,993,340
862,61,35
984,92,344
425,690,689"
input = AdventOfCodeHelpers.get_input(8)

describe "Day 8" do
  describe "Part 1" do
    it "should pass the test input" do
      Day08.part_1(test_input, 10).should eq(40)

      answer = Day08.part_1(input, 1000)
      puts "Part 1: #{answer}"
      AdventOfCodeHelpers.submit_answer(8, answer.to_s, 1)
    end
  end

  describe "Part 2" do
    it "should pass the test input" do
      Day08.part_2(test_input).should eq(25272)

      answer = Day08.part_2(input)
      puts "Part 2: #{answer}"
      AdventOfCodeHelpers.submit_answer(8, answer.to_s, 2)
    end
  end
end
