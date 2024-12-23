require "minitest/autorun"

require_relative "./day_22"
require_relative "./helpers"

class Day22Test < Minitest::Test
  def self.test_order; :alpha; end # Stable test order for readability

  def setup
    @test_input = <<~INPUT
      1
      10
      100
      2024
    INPUT

    @test_input = @test_input.strip

    @input = AdventOfCodeHelpers.get_input(22)
  end

  def test_secret_evolution
    secret = 123

    secrets = [
      15887950,
      16495136,
      527345,
      704524,
      1553684,
      12683156,
      11100544,
      12249484,
      7753432,
      5908254,
    ]

    secrets.each do |s|
      secret = Day22.evolve_secret(secret)

      assert_equal s, secret
    end
  end

  def test_part_1
    assert_equal 37327623, Day22.part_1(@test_input)

    answer = Day22.part_1(@input)
    puts "Part 1: #{answer}"

    AdventOfCodeHelpers.submit_answer(22, answer, 1)
  end

  def test_part_2
    @test_input = <<~INPUT
      1
      2
      3
      2024
    INPUT
    assert_equal 23, Day22.part_2(@test_input)

    answer = Day22.part_2(@input)
    puts "Part 2: #{answer}"

    AdventOfCodeHelpers.submit_answer(22, answer, 2)
  end
end
