class Day24
  Rule = Struct.new(:a, :op, :b, :result)

  def self.parse(input)
    states_str, rules = input.split("\n\n")

    states = {}
    states_str.split("\n").each do |line|
      key, val = line.split(": ")

      states[key] = val.to_i
    end

    rules = rules.split("\n").map do |line|
      equation, result = line.split(" -> ")

      a, op, b = equation.split(" ")

      Rule.new(a, op.to_sym, b, result)
    end

    return states, rules
  end

  def self.part_1(input)
    states, rules = parse(input)

    until rules.all? { |rule| states[rule.result] }
      rules.each do |rule|
        if states[rule.a] && states[rule.b]
          case rule.op
          when :OR
            states[rule.result] = states[rule.a] | states[rule.b]
          when :AND
            states[rule.result] = states[rule.a] & states[rule.b]
          when :XOR
            states[rule.result] = states[rule.a] ^ states[rule.b]
          else
            raise "Unknown operator: #{rule.op}"
          end
        end
      end
    end

    zs = states.filter { |k, v| k.start_with?("z") }.to_a.sort_by { |k, v| k }.map { |k, v| v }.join("").reverse.to_i(2)
  end

  def self.part_2(input)
    return 0
  end
end
