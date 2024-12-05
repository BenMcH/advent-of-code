class Day05
  def self.is_valid?(rules, line)
    rules.all? do |rule|
      a, b = rule

      if line.include?(a) && line.include?(b)
        line.index(a) < line.index(b)
      else
        true
      end
    end
  end

  def self.part_1(input)
    rules, input = input.split("\n\n")

    rules = rules.split("\n").map do |rule|
      rule.split("|").map(&:to_i)
    end

    input = input.split("\n").map do |line|
      line.split(",").map(&:to_i)
    end

    valid_lines = input.filter { |line| is_valid?(rules, line) }

    valid_lines.map do |line|
      line[line.length / 2]
    end.sum
  end

  def self.fix_line(rules, line)
    mixed_up = rules.find do |rule|
      a, b = rule

      line.include?(a) && line.include?(b) && line.index(a) > line.index(b)
    end

    if mixed_up.nil?
      return line
    end

    a_idx = line.index(mixed_up[0])
    b_idx = line.index(mixed_up[1])

    l = line.dup
    l[a_idx] = mixed_up[1]
    l[b_idx] = mixed_up[0]

    fix_line(rules, l)
  end

  def self.part_2(input)
    rules, input = input.split("\n\n")

    rules = rules.split("\n").map do |rule|
      rule.split("|").map(&:to_i)
    end

    input = input.split("\n").map do |line|
      line.split(",").map(&:to_i)
    end

    invalid_lines = input.filter { |line| !is_valid?(rules, line) }

    fixed_lines = invalid_lines.map do |line|
      fix_line(rules, line)
    end

    fixed_lines.map do |line|
      line[line.length / 2]
    end.sum
  end
end
