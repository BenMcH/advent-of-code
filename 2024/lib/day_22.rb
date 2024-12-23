class Day22
  def self.evolve_secret(secret)
    mix = Proc.new { |x, y| x ^ y }
    prune = Proc.new { |x| x % 16777216 }

    num = secret << 6
    secret = mix.call(num, secret)
    secret = prune.call(secret)

    num = secret >> 5
    secret = mix.call(num, secret)
    secret = prune.call(secret)

    num = secret << 11
    secret = mix.call(num, secret)
    secret = prune.call(secret)

    secret
  end

  def self.part_1(input)
    input = input.split("\n").map(&:to_i)

    2000.times do
      input = input.map { |i| Day22.evolve_secret(i) }
    end

    return input.sum
  end

  def self.part_2(input)
    return 0
  end
end
