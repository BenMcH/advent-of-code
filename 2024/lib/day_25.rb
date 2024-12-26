class Day25
  def self.parse(input)
    input = input.strip.split("\n\n").map do |section|
      section.split("\n").map(&:chars)
    end

    locks = input.filter do |potential_lock|
      potential_lock[0].all? { |c| c == "#" }
    end

    keys = input.filter do |potential_key|
      potential_key[-1].all? { |c| c == "#" }
    end

    return locks, keys
  end

  def self.part_1(input)
    locks, keys = parse(input)

    locks.product(keys).count do |lock, key|
      key.zip(lock).all? do |key_row, lock_row|
        lock_row.zip(key_row).all? do |lock_col, key_col|
          [lock_col, key_col].count("#") < 2
        end
      end
    end
  end

  def self.part_2(input)
    return 0
  end
end
