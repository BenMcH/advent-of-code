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

    tokens = Float::INFINITY

    for a in 0..(prizex / ax).floor
      loc = [ax * a, ay * a]

      diff = [prizex - loc[0], prizey - loc[1]]

      modx = diff[0] % bx
      mody = diff[1] % by

      if modx == 0 && mody == 0 && diff[0] / bx == diff[1] / by
        cur_tokens = 3 * a + (diff[0] / bx)
        tokens = cur_tokens if cur_tokens < tokens
      end
    end

    tokens
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
