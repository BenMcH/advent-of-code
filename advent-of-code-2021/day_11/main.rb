def neighbors(input, row, col)
	locs = []
	locs << [row-1, col] if row > 0
	locs << [row+1, col] if row < input.length - 1
	locs << [row, col-1] if col > 0
	locs << [row, col+1] if col < input[row].length - 1
	locs << [row-1, col-1] if row > 0 && col > 0
	locs << [row-1, col+1] if row > 0 && col < input[row].length - 1
	locs << [row+1, col+1] if row < input.length - 1 && col < input[row].length - 1
	locs << [row+1, col-1] if row < input.length - 1 && col > 0

	locs
end

def step(input)
	flashes = 0
	flashed = []
	new_input = input.map.with_index do |row, i|
		row.map.with_index do |cell, j|
			if cell == 9
				flashed << [i, j]
				flashes += 1
			end
			cell + 1
		end
	end

	while flashed.length > 0
		flash = flashed.pop

		neighbors(new_input, flash[0], flash[1]).each do |coord|
			val = new_input[coord[0]][coord[1]]
			if val == 9
				flashed.unshift(coord)
				flashes += 1
			end

			new_input[coord[0]][coord[1]] += 1
		end
	end

	new_input = new_input.map do |row|
		row.map do |cell|
			cell > 9 ? 0 : cell
		end
	end

	return new_input, flashes
end

def part_1(input)
	flashes = 0
	new_input = input

	100.times do
		new_input, inner_flash = step(new_input)
		flashes += inner_flash
	end

	flashes
end

example_input = File.read('example.txt').split("\n").map {|row| row.split('').map(&:to_i)}
ex_output = part_1(example_input)

throw Exception.new("Part 1 is not 1656, got: #{ex_output}" ) if ex_output != 1656

input = File.read('input.txt').split("\n").map {|row| row.split('').map(&:to_i)}

p part_1(input)

def part_2(input)
	i = 0
	target_len = input.sum {|row| row.length }
	flashed = 0
	new_input = input
	until flashed == target_len do
		i += 1
		new_input, flashed = step(new_input)
	end

	i
end

ex_output = part_2(example_input)
throw Exception.new("Part 2 is not 195, got: #{ex_output}") if ex_output != 195

p part_2(input)
