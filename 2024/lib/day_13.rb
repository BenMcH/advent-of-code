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

  def self.solve(game)
    ax, ay = game.a
    bx, by = game.b
    prizex, prizey = game.prize

    tokens = Float::INFINITY

    for a in 0..(prizex / ax).floor
      loc = [ax * a, ay * a]
      for b in 0..(prizey / by).floor
        b_loc = [bx * b, by * b]
        total_loc = [loc[0] + b_loc[0], loc[1] + b_loc[1]]

        break if total_loc[0] > prizex || total_loc[1] > prizey

        if total_loc[0] == prizex && total_loc[1] == prizey
          cur_tokens = 3 * a + b
          tokens = cur_tokens if cur_tokens < tokens

          break
        end
      end
    end

    tokens
  end

  def self.part_1(input)
    games = parse(input).map { |game| solve(game) }.filter { |tokens| tokens != Float::INFINITY }

    return games.sum
  end

  def self.part_2(input)
    return 0
  end
end
