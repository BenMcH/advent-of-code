require "minitest/autorun"

require_relative "./day_23"
require_relative "./helpers"

class Day23Test < Minitest::Test
  def self.test_order; :alpha; end # Stable test order for readability

  def setup
    @test_input = <<~INPUT
      kh-tc
      qp-kh
      de-cg
      ka-co
      yn-aq
      qp-ub
      cg-tb
      vc-aq
      tb-ka
      wh-tc
      yn-cg
      kh-ub
      ta-co
      de-co
      tc-td
      tb-wq
      wh-td
      ta-ka
      td-qp
      aq-cg
      wq-ub
      ub-vc
      de-ta
      wq-aq
      wq-vc
      wh-yn
      ka-de
      kh-ta
      co-tc
      wh-qp
      tb-vc
      td-yn
    INPUT

    @test_input = @test_input.strip

    @input = AdventOfCodeHelpers.get_input(23)
  end

  def test_part_1
    assert_equal 7, Day23.part_1(@test_input)

    answer = Day23.part_1(@input)
    puts "Part 1: #{answer}"

    AdventOfCodeHelpers.submit_answer(23, answer, 1)
  end

  def test_part_2
    assert_equal "co,de,ka,ta", Day23.part_2(@test_input)

    answer = Day23.part_2(@input)
    puts "Part 2: #{answer}"

    AdventOfCodeHelpers.submit_answer(23, answer, 2)
  end
end
