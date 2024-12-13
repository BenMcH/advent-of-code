class Day13
  Game = Struct.new(
    :a,
    :b,
    :prize
  )

  def self.parse(input)
    input.split("\n\n").map do |section|
      a, b, prize = section.split("\n")

      a = a.scan(/\d+/).map(&:to_i)
      b = b.scan(/\d+/).map(&:to_i)
      prize = prize.scan(/\d+/).map(&:to_i)

      Game.new(a, b, prize)
    end
  end

  def self.solve(game, p2 = false)
    ax, ay = game.a
    bx, by = game.b
    prizex, prizey = game.prize

    if p2
      prizex += 10000000000000
      prizey += 10000000000000
    end

    d = ax * by - ay * bx

    dx = prizex * by - prizey * bx
    dy = ax * prizey - ay * prizex

    x = dx.to_f / d
    y = dy.to_f / d

    return Float::INFINITY if x < 0 || x.to_i != x || y < 0 || y.to_i != y

    return 3 * x.to_i + y.to_i
  end

  def self.part_1(input)
    games = parse(input).map { |game| solve(game) }.filter { |tokens| tokens != Float::INFINITY }

    return games.sum
  end

  def self.part_2(input)
    games = parse(input).map { |game| solve(game, true) }.filter { |tokens| tokens != Float::INFINITY }

    return games.sum
  end
end
