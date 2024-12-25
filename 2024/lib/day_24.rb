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
    states, rules = parse(input)

    problematic_rules = rules.filter do |rule|
      if rule.result.start_with?("z")
        rule.op != :XOR && rule.result != "z45"
      elsif !"xy".include?(rule.a[0])
        rule.op == :XOR
      end
    end

    puts "Known bad rules: #{problematic_rules.map { |r| r.result }.sort.join(",")}"
    puts "Look for remaining 2 rules using graphviz output. Then manually solve."
    puts "Generate svg with `dot -T svg dot.gv -o dot.svg`"

    zs = rules.map { |rule| rule.result }.filter { |result| result.start_with?("z") }.sort.join(" -> ")
    xs = states.map { |k, v| k }.filter { |k| k.start_with?("x") }.sort.join(" -> ")
    ys = states.map { |k, v| k }.filter { |k| k.start_with?("y") }.sort.join(" -> ")

    graphs = rules.flat_map do |rule|
      [
        "#{rule.a} -> #{rule.result}",
        "#{rule.b} -> #{rule.result}",
      ]
    end.join(" ")

    group = rules.group_by { |r| r.op }

    File.write "./dot.gv", <<~DOT
                 digraph G {
                    subgraph {
                       node [style=filled,color=green]
                        #{zs}
                    }
                    subgraph {
                        node [style=filled,color=gray]
                        #{xs}
                    }
                    subgraph {
                        node [style=filled,color=gray]
                        #{ys}
                    }
                    subgraph {
                        node [style=filled,color=pink]
                        #{group[:AND].map { |r| r.result }.join(" ")}
                    }
                    subgraph {
                        node [style=filled,color=yellow];
                        #{group[:OR].map { |r| r.result }.join(" ")}
                    }
                    subgraph {
                        node [style=filled,color=lightblue];
                        #{group[:XOR].map { |r| r.result }.join(" ")}
                    }
                    
                    #{graphs}
                   }
               DOT

    nil
  end
end
