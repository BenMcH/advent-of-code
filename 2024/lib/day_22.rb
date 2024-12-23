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
      _output = Hash.new(0)

      2000.times do
        j = evolve_secret(i)

        n = (j % 10) - (i % 10)
        i = j

        out << n

        if out.length >= 4
          key = out[-4..-1]

          unless _output.key?(key)
            _output[key] = true
            answer_hash[key] += j % 10
          end
        end
      end
    end

    answer_hash.values.max
  end
end
