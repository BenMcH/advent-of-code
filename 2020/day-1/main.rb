numbers = File.read('./data.txt').split.map(&:to_i)

first_pair = numbers.product(numbers).find{|pair| pair.reduce(&:+) == 2020}

puts first_pair.reduce(&:*)

first_triplet = numbers.product(numbers, numbers).find{|set| set.reduce(&:+) == 2020}

puts first_triplet.reduce(&:*)
