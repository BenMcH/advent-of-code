require "spec"

require "../src/day_ZPDAY"
require "../helpers"

test_input = "".strip
input = AdventOfCodeHelpers.get_input(DAY)

describe "Day DAY" do
  describe "Part 1" do
    it "should pass the test input" do
      test_input = test_input.strip

      DayZPDAY.part_1(test_input).should eq(1)

      answer =  DayZPDAY.part_1(input)
      puts "Part 1: #{answer}"
    end
  end

  describe "Part 2" do
    it "should pass the test input", tags: "skip" do
      test_input = "
            "
      test_input = test_input.strip

      DayZPDAY.part_2(test_input).should eq(1)

      answer =  DayZPDAY.part_2(input)
      puts "Part 2: #{answer}"
    end
  end
end
