require "set"

class Day22
  def self.evolve_secret(secret, steps = 1)
    steps.times do
      secret = ((secret * 64) ^ secret) % 16777216
      secret = ((secret / 32) ^ secret) % 16777216
      secret = ((secret * 2048) ^ secret) % 16777216
    end

    secret
  end

  def self.part_1(input)
    input = input.split("\n").map(&:to_i)

    total = 0

    input.each do |i|
      total += Day22.evolve_secret(i, 2000)
    end

    total
  end

  def self.part_2(input)
    input = input.split("\n").map(&:to_i)
    answer_hash = Hash.new(0)

    input.each_with_index do |i, idx|
      out = []
      _output = Set.new
      diffs = 0

      4.times do
        old_price = i % 10
        i = evolve_secret(i)
        new_price = i % 10
        # adjust range from (-9, 9) to (0, 18) (00000 to 10010)
        diffs = (diffs << 5) + (new_price - old_price + 9)
      end

      1996.times do
        old_price = i % 10
        i = evolve_secret(i)
        new_price = i % 10

        diffs = ((diffs & 0x7FFF) << 5) + (new_price - old_price + 9)

        answer_hash[diffs] += new_price unless _output.include?(diffs)
        _output << diffs
      end
    end

    answer_hash.values.max
  end
end
