require "minitest/autorun"

require_relative "./day_10"
require_relative "./helpers"

class Day10Test < Minitest::Test
  def self.test_order; :alpha; end # Stable test order for readability

  def setup
    @test_input = <<~INPUT
position=< 9,  1> velocity=< 0,  2>
position=< 7,  0> velocity=<-1,  0>
position=< 3, -2> velocity=<-1,  1>
position=< 6, 10> velocity=<-2, -1>
position=< 2, -4> velocity=< 2,  2>
position=<-6, 10> velocity=< 2, -2>
position=< 1,  8> velocity=< 1, -1>
position=< 1,  7> velocity=< 1,  0>
position=<-3, 11> velocity=< 1, -2>
position=< 7,  6> velocity=<-1, -1>
position=<-2,  3> velocity=< 1,  0>
position=<-4,  3> velocity=< 2,  0>
position=<10, -3> velocity=<-1,  1>
position=< 5, 11> velocity=< 1, -2>
position=< 4,  7> velocity=< 0, -1>
position=< 8, -2> velocity=< 0,  1>
position=<15,  0> velocity=<-2,  0>
position=< 1,  6> velocity=< 1,  0>
position=< 8,  9> velocity=< 0, -1>
position=< 3,  3> velocity=<-1,  1>
position=< 0,  5> velocity=< 0, -1>
position=<-2,  2> velocity=< 2,  0>
position=< 5, -2> velocity=< 1,  2>
position=< 1,  4> velocity=< 2,  1>
position=<-2,  7> velocity=< 2, -2>
position=< 3,  6> velocity=<-1, -1>
position=< 5,  0> velocity=< 1,  0>
position=<-6,  0> velocity=< 2,  0>
position=< 5,  9> velocity=< 1, -2>
position=<14,  7> velocity=<-2,  0>
position=<-3,  6> velocity=< 2, -1>
    INPUT

    @test_input = @test_input.strip

    @input = AdventOfCodeHelpers.get_input(10)
  end

  def test_part_1
    # assert_equal 1, Day10.part_1(@test_input)

    answer = Day10.part_1(@input)
    #puts "Part 1: #{answer}"

    #AdventOfCodeHelpers.submit_answer(10, answer, 1)
  end

  def test_part_2
    skip("Part 2 not yet implemented")
    assert_equal 1, Day10.part_2(@test_input)

    answer = Day10.part_2(@input)
    puts "Part 2: #{answer}"

    AdventOfCodeHelpers.submit_answer(10, answer, 2)
  end
end
