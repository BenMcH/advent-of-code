def build_polymers(polymers)
	polymers.split("\n").map do |x|
		a, b = x.split(' -> ')

		[a, "#{a[0]}#{b}#{a[1]}"]
	end.to_h
end

def simulate_day(counts, polymers, count = 1)
	new_counter = {}
	counts.keys.each.with_index do |key, i|
		polymer = polymers[key]

		polymer.split('').each_cons(2).map do |a, b|
			key2 = "#{a}#{b}"
			new_counter[key2] = new_counter[key2].to_i + counts[key]
		end

	end

	return count == 1 ? new_counter : simulate_day(new_counter, polymers, count - 1)
end

def count_letters(counts)
	new_counts = {}

	counts.keys.each do |key|
		new_counts[key[0]] = new_counts[key[0]].to_i + counts[key]
	end

	new_counts
end

def run_for_days(start, polymers, days)
	str = start.split('')

	polymers = build_polymers(polymers)

	counts = str.each_cons(2).map(&:join).tally

	result = simulate_day(counts, polymers, days)

	result = count_letters(result)
	result[str[-1]] += 1

	min, max = result.to_a.map(&:last).minmax

	max - min
end

ex_start, ex_polymers = File.read('example.txt').split("\n\n")
ans = run_for_days(ex_start, ex_polymers, 10)

throw Exception.new("Part 1 is not 1588, got: #{ans}" ) if 1588 != ans

start, polymers = File.read('input.txt').split("\n\n")

p run_for_days(start, polymers, 10)

ans = run_for_days(ex_start, ex_polymers, 40)
throw Exception.new("Part 2 is not 2188189693529, got: #{ans}") if ans != 2188189693529

p run_for_days(start, polymers, 40)
