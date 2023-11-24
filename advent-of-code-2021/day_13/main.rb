def create_board(input)
	rows = input.split("\n").map do |line|
		x, y = line.split(",").map(&:to_i)
		[y, x]
	end

	max_x = rows.map(&:last).max + 1
	max_y = rows.map(&:first).max + 1


	x_row = (0...max_x).to_a.map{ nil }
	arr = []
	max_y.times do |y|
		arr[y] = x_row.dup
	end

	rows.each do |y, x|
		arr[y][x] = '#'
	end

	arr
end

def print_board(arr)
	arr.each do |row|
		p row.map{ |cell| cell || '.' }.join
	end

	p '-' * 20
end

def fold_board(board, y)
	top = board[0...y]
	bottom = board[y + 1..-1].reverse
	bottom_offset = top.length - bottom.length

	new_board = top.map.with_index do |row, y|
		row.map.with_index do |cell, x|
			if y >= bottom_offset
				bottom_val = bottom[y] ? bottom[y][x] : nil
				cell || bottom[y - bottom_offset][x]
			else
				cell
			end
		end
	end

	new_board
end

def part_1(board, folds)
	board = create_board(board)

	line =  folds.split("\n").first
	line = line[11..-1]
	number = line[2..-1].to_i
 
	if line[0] == 'y'
		board = fold_board(board, number)
	else
		board = board.transpose
		board = fold_board(board, number)
		board = board.transpose
	end
	board.sum{ |row| row.count('#') }
end

example_board_instructions, example_folds = File.read('example.txt').split("\n\n")

ans = part_1(example_board_instructions, example_folds)
throw Exception.new("Part 1 is not 17, got: #{ans}" ) if 17 != ans

board_instructions, folds = File.read('input.txt').split("\n\n")

p part_1(board_instructions, folds)

def part_2(board, folds)
	board = create_board(board)

	folds.split("\n").each do |line|
		line = line[11..-1]
		number = line[2..-1].to_i
	
		if line[0] == 'y'
			board = fold_board(board, number)
		else
			board = board.transpose
			board = fold_board(board, number)
			board = board.transpose
		end
	end

	print_board(board)
end

part_2(board_instructions, folds)
