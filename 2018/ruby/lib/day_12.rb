class Day12
  Rule = Struct.new(:l2, :l1, :c, :r1, :r2, :result) do
    def try_apply(pots, pot)
      (-4..0).each do |i|
        _pot = pot + i
        _l2, _l1, _c, _r1, _r2 = pots[_pot], pots[_pot + 1], pots[_pot + 2], pots[_pot + 3], pots[_pot + 4]

        if l2 == _l2 && l1 == _l1 && c == _c && r1 == _r1 && r2 == _r2
          return _pot + 2, result
        end
      end

      return nil, nil
    end
  end

  def self.parse(input)
    input, rules = input.split("\n\n")

    h = Hash.new(".")

    input.split(": ")[1].chars.each_with_index { |c, i| h[i] = c if c == "#" }
    rules = rules.split("\n").map do |rule|
      rule = rule.split(" => ").flat_map(&:chars)

      Rule.new(*rule)
    end

    return h, rules
  end

  def self.generation(pots, rules)
    new_pots = pots.dup
    
    rules.each do |r|
    pots.each do |k, v|
        i, new_val = r.try_apply(pots, k)

        unless i.nil?
          if new_val == "#"
            new_pots[i] = new_val
          else
            new_pots.delete(i)
          end
        end
      end
    end

    return new_pots
  end

  def self.part_1(input)
    input, rules = parse(input)

    20.times {
      input = generation(input, rules)
    }

    input.keys.sum
  end
  
  def self.part_2(input)
    input, rules = parse(input)

    sum = input.keys.sum
    diffs = []
    1000.times do |x|
      input = generation(input, rules)

      _sum = input.keys.sum
      diffs << _sum - sum

      if diffs[-1] == diffs[-2] && diffs[-1] == diffs[-3]
        return (50_000_000_000 - (x + 1)) * diffs[-1] + _sum
      end

      sum = _sum
    end
  end
end
