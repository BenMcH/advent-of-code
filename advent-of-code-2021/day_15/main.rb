def get_neighbors(input, y, x)
	neighbors = []

	neighbors << [y - 1, x] if y > 0
	neighbors << [y + 1, x] if y < input.length - 1
	neighbors << [y, x - 1] if x > 0
	neighbors << [y, x + 1] if x < input[y].length - 1

	neighbors
end

def part_1(input)
	distances = input.map.with_index do |row|
		row.map {|cell| Float::INFINITY}
	end
	distances[0][0] = 0
	queue = [[0, 0]]

	until queue.empty?
		y, x = queue.shift
		current_score = distances[y][x]

		get_neighbors(input, y, x).each do |neighbor|
			ny, nx = neighbor
			cost = input[ny][nx]

			if current_score + cost < distances[ny][nx]
				distances[ny][nx] = current_score + cost
				queue << neighbor
			end
		end
	end

	distances.last.last
end

example_input = File.read('example.txt').split("\n").map {|row| row.split('').map(&:to_i)}
ex_output = part_1(example_input)

throw Exception.new("Part 1 is not 40, got: #{ex_output}" ) if ex_output != 40

input = File.read('input.txt').split("\n").map {|row| row.split('').map(&:to_i)}

p part_1(input)

def increment_row(row, increments = 1)
	new_row = row

	increments.times do
		new_row = new_row.map do |cell|
			cell == 9 ? 1 : cell + 1
		end
	end

	new_row
end

def increment_board(input, times = 1)
	new_board = input

	times.times do
		new_board = new_board.map do |row|
			increment_row(row)
		end
	end

	new_board
end

def make_larger_board(input)
	board = input.map do |row|
		row + increment_row(row) + increment_row(row, 2) + increment_row(row, 3) + increment_row(row, 4)
	end
	original_board = board.dup

	4.times do |x|
		board.concat(increment_board(original_board, x + 1))
	end

	board
end

def part_2(input)
	part_1(make_larger_board(input))
end

ex_output = part_2(example_input)
throw Exception.new("Part 2 is not 315, got: #{ex_output}") if ex_output != 315

p part_2(input)
