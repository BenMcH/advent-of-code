class Day19
  def self.parse(input)
    a, b = input.split("\n\n")

    a = a.scan(/\w+/)
    b = b.split("\n")

    return a, b
  end

  def self.count_arrangements(patterns, candidate, cache)
    if cache.key?(candidate)
      return cache[candidate]
    end

    count = 0

    patterns.each do |pattern|
      if candidate.start_with?(pattern)
        c = count_arrangements(patterns, candidate[pattern.length..], cache)

        if c > 0
          count += c
        end
      end
    end

    cache[candidate] = count

    return count
  end

  def self.part_1(input)
    patterns, candidates = parse(input)

    cache = Hash.new(0)
    cache[""] = 1

    return candidates.count { |c|
             count_arrangements(patterns, c, cache) > 0
           }
  end

  def self.part_2(input)
    patterns, candidates = parse(input)

    cache = Hash.new(0)
    cache[""] = 1

    candidates.map { |c| count_arrangements(patterns, c, cache) }.sum
  end
end
