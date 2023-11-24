require 'aoc/helpers'

test_input = File.read('./test-input.txt')
real_input = get_input(2022, 14, File.read('/home/vscode/.adventofcode.session'))

part_1_expected = 24
part_2_expected = 93

def parse_input(input)
	board = {}

	lines(input).each{ |l|
		last_coords = nil
		l.split(" -> ").each do |coord|
			x, y = *coord.split(",").map(&:to_i)

			unless last_coords
				board[[x,y]] = '#'
			else
				if last_coords[0] == x
					min, max = *[last_coords[1], y].minmax
					(min..max).each do |y|
						board[[x, y]] = '#'
					end
				else
					min, max = *[last_coords[0], x].minmax
					(min..max).each do |x|
						board[[x, y]] = '#'
					end
				end
			end
			last_coords = [x, y]
		end
	}

	board
end

def print_board(board)
	keys = board.keys
	low_x = keys.map(&:first).min
	high_x = keys.map(&:first).max
	low_y = keys.map(&:last).min
	high_y = keys.map(&:last).max

	str = ""
	(low_y..high_y).each do |y|
		(low_x..high_x).each do |x|
			str += (board[[x, y]] || " ")
		end
		str += "\n"
	end

	str
end

def get_lowest_point(board)
	board.keys.map(&:last).max
end

def is_abyss(board, loc, lowest_point, floor)
	y = loc[1] + 1

	return false if floor
	(y..lowest_point).all? {|new_y| board[[loc[0], new_y]].nil?}
end

def simulate_sand(board, lowest_point, floor = false, sand_loc = [500, 0])
	if is_abyss(board,sand_loc, lowest_point, floor)
		return nil
	end

	down = sand_loc.dup
	down[1] += 1

	floor_modifier = floor ? 2 : 0
	true_lowest = lowest_point + floor_modifier

	return [sand_loc[0], true_lowest - 1] if floor && down[1] >= true_lowest

	if board[down].nil?
		loop do
			down[1]+=1

			break if down[1] >= true_lowest || board[down]
		end
		down[1] -=1 if board[down]
		return simulate_sand(board, lowest_point, floor, down)
	end

	left = down.dup
	left[0] -= 1
	unless board[left]
		return simulate_sand(board, lowest_point, floor, left)
	end

	right = down.dup
	right[0] += 1
	unless board[right]
		return simulate_sand(board, lowest_point, floor, right)
	end

	sand_loc
end

def solution_part_1(input)
	board = parse_input(input)
	lowest_point = get_lowest_point(board)

	count = 0
	successful = true
	while successful
		next_coord = simulate_sand(board, lowest_point)

		successful = !next_coord.nil?
		if successful
			board[next_coord] = '.' 
			count += 1
		end
	end

	return count
end

def solution_part_2(input)
	board = parse_input(input)
	lowest_point = get_lowest_point(board)

	count = 0
	successful = true
	until board[[500, 0]]
		next_coord = simulate_sand(board, lowest_point, true)

		board[next_coord] = '.' 
		count += 1
	end

	return count
end

describe "Day 14" do
	
	it "Part 1 should pass" do
		expect(solution_part_1(test_input)).to eq(part_1_expected)
		p solution_part_1(real_input)
	end

	it "Part 2 should pass" do
		expect(solution_part_2(test_input)).to eq(part_2_expected)
		p solution_part_2(real_input)
	end
end
