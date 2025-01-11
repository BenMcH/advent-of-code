require "minitest/autorun"

require_relative "./day_13"
require_relative "./helpers"

class Day13Test < Minitest::Test
  def self.test_order; :alpha; end # Stable test order for readability

  def setup
    @test_input = <<~INPUT
      /->-\\        
      |   |  /----\\
      | /-+--+-\\  |
      | | |  | v  |
      \\-+-/  \\-+--/
        \\------/   
    INPUT

    @test_input = @test_input.strip

    @input = AdventOfCodeHelpers.get_input(13)
  end

  def test_part_1
    assert_equal '7,3', Day13.part_1(@test_input)

    answer = Day13.part_1(@input)
    puts "Part 1: #{answer}"

    AdventOfCodeHelpers.submit_answer(13, answer, 1)
  end

  def test_part_2
    @test_input = <<~INPUT
/>-<\\  
|   |  
| /<+-\\
| | | v
\\>+</ |
  |   ^
  \\<->/
    INPUT
    assert_equal "6,4", Day13.part_2(@test_input)

    answer = Day13.part_2(@input)
    puts "Part 2: #{answer}"

    AdventOfCodeHelpers.submit_answer(13, answer, 2)
  end
end
