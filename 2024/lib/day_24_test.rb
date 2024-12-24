require "minitest/autorun"

require_relative "./day_24"
require_relative "./helpers"

class Day24Test < Minitest::Test
  def self.test_order; :alpha; end # Stable test order for readability

  def setup
    @test_input = <<~INPUT
      x00: 1
      x01: 0
      x02: 1
      x03: 1
      x04: 0
      y00: 1
      y01: 1
      y02: 1
      y03: 1
      y04: 1

      ntg XOR fgs -> mjb
      y02 OR x01 -> tnw
      kwq OR kpj -> z05
      x00 OR x03 -> fst
      tgd XOR rvg -> z01
      vdt OR tnw -> bfw
      bfw AND frj -> z10
      ffh OR nrd -> bqk
      y00 AND y03 -> djm
      y03 OR y00 -> psh
      bqk OR frj -> z08
      tnw OR fst -> frj
      gnj AND tgd -> z11
      bfw XOR mjb -> z00
      x03 OR x00 -> vdt
      gnj AND wpb -> z02
      x04 AND y00 -> kjc
      djm OR pbm -> qhw
      nrd AND vdt -> hwm
      kjc AND fst -> rvg
      y04 OR y02 -> fgs
      y01 AND x02 -> pbm
      ntg OR kjc -> kwq
      psh XOR fgs -> tgd
      qhw XOR tgd -> z09
      pbm OR djm -> kpj
      x03 XOR y03 -> ffh
      x00 XOR y04 -> ntg
      bfw OR bqk -> z06
      nrd XOR fgs -> wpb
      frj XOR qhw -> z04
      bqk OR frj -> z07
      y03 OR x01 -> nrd
      hwm AND bqk -> z03
      tgd XOR rvg -> z12
      tnw OR pbm -> gnj
    INPUT

    @test_input = @test_input.strip

    @input = AdventOfCodeHelpers.get_input(24)
  end

  def test_part_1
    assert_equal 2024, Day24.part_1(@test_input)

    answer = Day24.part_1(@input)
    puts "Part 1: #{answer}"

    AdventOfCodeHelpers.submit_answer(24, answer, 1)
  end

  def test_part_2
    skip("Part 2 not yet implemented")
    assert_equal 1, Day24.part_2(@test_input)

    answer = Day24.part_2(@input)
    puts "Part 2: #{answer}"

    AdventOfCodeHelpers.submit_answer(24, answer, 2)
  end
end
