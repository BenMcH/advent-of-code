rules, messages = File.read('./data.txt').split("\n\n")
rules = rules.split("\n")
messages = messages.split("\n")

rule_book = {}
rules.each do |rule|
    start, criteria = /(\d+): (.*)/.match(rule).captures
    start = start.to_i
    criteria = criteria.gsub('"', '').split(' | ').map{|r| r.split(' ').map{|i| i.to_i === 0 ? i : i.to_i} }
    rule_book[start] = criteria
end

def build_regex(rule_set, i=0)
    j = rule_set[i].map{|r| r.flat_map {|s| s.kind_of?(String) ? s : build_regex(rule_set, s)}.join}.join("|")

    j.length == 1 ? j : "(#{j})"
end

regex = "^#{build_regex(rule_book)}$"
regex =  Regexp.new(regex)

p messages.count{|m| regex.match? m }

rule_book[8] = [[42, '+']]
rule_book[11] = (1..10).map {|i| [42] * i + [31] * i} # It _probably_ won't be hit more than 10 iterations

regex = "^#{build_regex(rule_book)}$"
regex =  Regexp.new(regex)

p messages.count{|m| regex.match? m }
