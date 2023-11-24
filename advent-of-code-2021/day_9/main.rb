
def part_1(input)
	input_lines = input.split("\n").map do |line|
		line.split("").map(&:to_i)
	end

	low_points = []

	input_lines.each_with_index do |line, y|
		ys = []
		ys << y + 1 if y < input_lines.length - 1
		ys << y - 1 if y > 0

		line.each_with_index do |value, x|
			xs = []
			xs << x + 1 if x < input_lines[y].length - 1
			xs << x - 1 if x > 0

			if ys.all? { |inner_y| input_lines[inner_y][x] > value } && xs.all? { |inner_x| input_lines[y][inner_x] > value }
				low_points << [y, x]
			end
		end
	end

	low_points.map { |point| input_lines[point[0]][point[1]] + 1 }.sum
end


example_input = File.read('example.txt')
ex_output = part_1(example_input)

throw Exception.new("Part 1 is not 15, got: #{ex_output}" ) if ex_output != 15

input = File.read('input.txt')

p part_1(input)

def flood_fill(input, x, y, arr = [[y, x]])
	ys = []
	ys << y + 1 if y < input.length - 1
	ys << y - 1 if y > 0
	xs = []
	xs << x + 1 if x < input[y].length - 1
	xs << x - 1 if x > 0

	ys.each do |inner_y|
		if input[inner_y][x] > input[y][x] && input[inner_y][x] <= 8
			arr << [inner_y, x]
			flood_fill(input, x, inner_y, arr)
		end
	end
	xs.each do |inner_x|
		if input[y][inner_x] > input[y][x] && input[y][inner_x] <= 8
			arr << [y, inner_x]
			flood_fill(input, inner_x, y, arr)
		end
	end

	return arr
end

def part_2(input)
	input_lines = input.split("\n").map do |line|
		line.split("").map(&:to_i)
	end

	basins = []

	input_lines.each_with_index do |line, y|
		ys = []
		ys << y + 1 if y < input_lines.length - 1
		ys << y - 1 if y > 0

		line.each_with_index do |value, x|
			xs = []
			xs << x + 1 if x < input_lines[y].length - 1
			xs << x - 1 if x > 0

			if ys.all? { |inner_y| input_lines[inner_y][x] > value } && xs.all? { |inner_x| input_lines[y][inner_x] > value }
				basins << flood_fill(input_lines, x, y).uniq
			end
		end
	end

	return basins.map(&:size).sort.last(3).reduce(&:*)
end

ex_output = part_2(example_input)
throw Exception.new("Part 2 is not 1134, got: #{ex_output}") if ex_output != 1134

p part_2(input)
