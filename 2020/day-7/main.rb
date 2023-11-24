rules = File.read('./data.txt').split("\n").map{|rule| rule.gsub(/\s?[.,]\s?/, '').gsub(/\scontain\s/, '').strip.split(/ bags?/)}

def recursive_find(rules, starting_point, all_matches = [])
    matches = rules.map do |rule|
        any = rule.find{|line| line != rule[0] && line.include?(starting_point)}

        any ? rule[0] : nil
    end.keep_if{|a| a != nil}

    branching_rules = matches.flat_map{ |rule|
        recursive_find(rules, rule)
    }

    return matches.concat(branching_rules).uniq
end

puts recursive_find(rules, 'shiny gold').length

mapped_rules = {}
rules.each do |rule|
    key, *values = rule

    mapped_rules[key] = values.map{|value| [value[0].to_i, value[2..-1]]}
end

def recursive_count(rules, name = 'shiny gold')
    rule = rules[name]

    rule.map do |individual_rule|
        count, set = individual_rule

        if !rules[set]
            count
        else
            count + count * recursive_count(rules, set)
        end
    end.reduce(&:+)
end

puts recursive_count(mapped_rules)
