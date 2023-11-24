input = File.read('input.txt').split(',').map(&:to_i)

def get_value(distance = 1, start = 1)
	distance == 0 ? 0 : start + get_value(distance - 1, start + 1)
end

min, max = input.minmax
range = min..max

results = range.map do |target|
	input.reduce(0) do |acc, sub|
		acc + (sub - target).abs
	end
end.min

p results

pt_2_distance = []

results = range.map do |target|
	input.reduce(0) do |acc, sub|
		moves = (sub - target).abs
		if !pt_2_distance[moves]
			pt_2_distance[moves] = get_value(moves)
		end
		acc + pt_2_distance[moves]
	end
end.min

p results
