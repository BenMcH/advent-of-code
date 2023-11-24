require 'aoc/helpers'

test_input = File.read('./test-input.txt')
real_input = get_input(2022, 22, File.read('/home/vscode/.adventofcode.session'))

part_1_expected = 6032
part_2_expected = 5031
WALL = "#"
FREE_SPACE = "."

# [y, x]
UP = [-1, 0]
DOWN = [1, 0]
LEFT = [0, -1]
RIGHT = [0, 1]

DIRECTIONS = [
	RIGHT,
	DOWN,
	LEFT,
	UP
]

def parse_input(input)
	board, instructions = input.split("\n\n")

	instructions = instructions.scan /\d+|R|L/
	board_lines = lines(board)
	max_len = board_lines.map(&:length).max

	board = board_lines.map{
		arr = _1.chars
		diff = max_len - arr.length

		additional = [' '] * diff

		arr.concat(additional)
	}

	[board, instructions]
end

def solution_part_1(input)
	board, instructions = *parse_input(input)

	pos = [0, board[0].index(FREE_SPACE)]
	current_direction = 0

	instructions.each do |instruction|
		num = instruction.to_i
		direction = DIRECTIONS[current_direction % DIRECTIONS.length]
		if num > 0 # was a number
			index = direction.find_index{_1 != 0}
			row = direction[0] == 0 ? board[pos[0]] : board.transpose[pos[1]]

			num.times do
				new_val = (direction[index] + pos[index]) % row.length
				new_val = (new_val + direction[index]) % row.length until row[new_val] != ' '

				if row[new_val] == '.'
					# pos = pos.dup

					pos[index] = new_val
				end

				break if row[new_val] == '#' # hit wall
			end
		else
			current_direction += (instruction == 'R' ? 1 : -1)
		end
	end

	1000 * (pos[0] + 1) + 4 * (pos[1] + 1) + (current_direction % DIRECTIONS.length)
end

def solution_part_2(input, block_size = 4)
	board, instructions = *parse_input(input)

	faces = []


	(0...(board.length / block_size)).each do |row_index|
		row = row_index * block_size
		(0...(board[row_index].length / block_size)).each do |col_index|
			col = col_index * block_size
			if board[row][col] != ' '
				face = []
				block_size.times do
					face << board[row+_1][col..(col+block_size)]
				end

				faces << face
			end
		end
	end

	pos = [0, board[0].index(FREE_SPACE)]
	current_direction = 0

	instructions.each do |instruction|
		num = instruction.to_i
		direction = DIRECTIONS[current_direction % DIRECTIONS.length]
		if num > 0 # was a number
			# p "Moving #{num} spaces"
			index = direction.find_index{_1 != 0}
			row = direction[0] == 0 ? board[pos[0]] : board.transpose[pos[1]]
			n_pos = pos.dup

			num.times do
				new_val = (direction[index] + pos[index]) % row.length

				# p "pos: #{n_pos}, new_val: #{new_val}, direction: #{direction}"

				if row[new_val] == ' '
					if index == 0 && new_val == 199 && (50..99).include?(n_pos[1])
						new_x = 0

						new_y = 100 + n_pos[1]
					# 	p "n_pos: #{n_pos}"
					# 	p "new y: #{new_y}"
						n_pos = [new_y, new_x]
						current_direction = 0
						direction = DIRECTIONS[current_direction]
						row = board[n_pos[0]]
						index = 1
					elsif index == 1 && new_val == 149 && (150..199).include?(n_pos[0])
					# 	# Down into face 0

						new_x = (n_pos[0] - 100)
					# 	p "new x: #{new_x}"
						new_y = 0
						n_pos = [new_y, new_x]
						current_direction = 1
						direction = DIRECTIONS[current_direction]
						row = board.transpose[n_pos[1]]
						index = 0
					elsif index == 1 && new_val == 49 && (0..49).include?(n_pos[0])
					# 	# left into right face 3
						new_x = 0
					# 0 -> 149
					# 49 -> 100
						new_y = 149 - pos[0]
						n_pos = [new_y, new_x]
						current_direction = 0
						direction = DIRECTIONS[current_direction]
						row = board[n_pos[0]]
						index = 1
					elsif index == 0 && new_val == 0 && (0..49).include?(n_pos[1])
						# down to down face 1
						new_x = pos[1] + 100
						new_y = 0
						n_pos = [new_y, new_x]
						current_direction = 1
						direction = DIRECTIONS[current_direction]
						row = board.transpose[n_pos[1]]
						index = 0
					elsif index == 0 && new_val == 150 && (50..99).include?(n_pos[1])
						# down to left face 5
						new_x = 49
						new_y = 150 + (n_pos[1] - 50)
						n_pos = [new_y, new_x]
						current_direction = 2
						direction = DIRECTIONS[current_direction]
						row = board[n_pos[0]]
						index = 1
					elsif index == 0 && new_val == 199 && (100..149).include?(n_pos[1])
						# up to up face 5
						new_x = n_pos[1] - 100
						new_y = board.length - 1
						n_pos = [new_y, new_x]
						current_direction = 3
						direction = DIRECTIONS[current_direction]
						row = board.transpose[n_pos[1]]
						index = 0
					elsif index == 1 && new_val == 0 && (0..49).include?(n_pos[0])
						# 0-149
						# 49-100
						# right to left face 4
						new_x = 99
						new_y = 149 - n_pos[0]
						n_pos = [new_y, new_x]
						current_direction = 2
						direction = DIRECTIONS[current_direction]
						row = board[n_pos[0]]
						index = 1
					elsif index == 1 && new_val == 100 && (100..149).include?(n_pos[0])
						# 149->0
						# 100->49
						# right from 4 to left 2
						new_x = board[0].length - 1
						new_y = 49 - (n_pos[0] - 100)
						n_pos = [new_y, new_x]
						current_direction = 2
						direction = DIRECTIONS[current_direction]
						row = board[n_pos[0]]
						index = 1
					elsif index == 1 && new_val == 50 && (150..199).include?(n_pos[0])
					# 	# right from 5 to up 4
						new_x = n_pos[0] - 100
						new_y = 149
						n_pos = [new_y, new_x]
						current_direction = 3
						direction = DIRECTIONS[current_direction]
						row = board.transpose[n_pos[1]]
						index = 0
					elsif index == 0 && new_val == 50 && (100..149).include?(n_pos[1])
					# 	# down from 1 to left 2
						new_x = 99
						new_y = n_pos[1] - 50
						n_pos = [new_y, new_x]
						current_direction = 2
						direction = DIRECTIONS[current_direction]
						row = board[n_pos[0]]
						index = 1
					elsif index == 1 && new_val == 49 && (50..99).include?(n_pos[0])
						# left from 2 -> down 3
						new_x = n_pos[0] - 50
						new_y = 100
						n_pos = [new_y, new_x]
						current_direction = 1
						direction = DIRECTIONS[current_direction]
						row = board.transpose[n_pos[1]]
						index = 0
					elsif index == 0 && new_val == 99 && (0..49).include?(n_pos[1])
						# up from 3 -> right 2
						new_x = 50
						new_y = n_pos[1] + 50
						n_pos = [new_y, new_x]
						current_direction = 0
						direction = DIRECTIONS[current_direction]
						row = board[n_pos[0]]
						index = 1
					elsif index == 1 && new_val == 149 && (100..149).include?(n_pos[0])
						# left from 3 to right on 0 inverted
						new_x = 50
						new_y = 149 - n_pos[0]
						n_pos = [new_y, new_x]
						current_direction = 0
						direction = DIRECTIONS[current_direction]
						row = board[n_pos[0]]
						index = 1
					elsif index == 1 && new_val == 100 && (50..99).include?(n_pos[0])
						# right from 2 to up on 1
						new_x = 50 + n_pos[0]
						new_y = 49
						n_pos = [new_y, new_x]
						current_direction = 3
						direction = DIRECTIONS[current_direction]
						row = board.transpose[n_pos[1]]
						index = 0
					else
						new_y, new_x = *n_pos
						if index == 0
							new_y = new_val
						else
							new_x = new_val
						end
						$stderr.puts "Unknown space: #{n_pos} #{new_y},#{new_x}, #{direction}, #{index}"
						return -1
					end

					break if board[n_pos[0]][n_pos[1]] == '#'
					p board[n_pos[0]][n_pos[1]]
					pos = n_pos
				else
					# 150-199 => 50 -> 99
					# new_val = (new_val + direction[index]) % row.length until row[new_val] != ' '

					if row[new_val] == '.'
						n_pos[index] = new_val
					end

					break if row[new_val] == '#' # hit wall
					pos = n_pos
				end
			end
		else
			# p "Turning #{instruction}"
			current_direction += (instruction == 'R' ? 1 : -1)
		end
	end

	p (pos[0] + 1), pos[1] + 1, current_direction % DIRECTIONS.length
	1000 * (pos[0] + 1) + 4 * (pos[1] + 1) + (current_direction % DIRECTIONS.length)
end

describe "Day 22" do
	it "Part 1 should pass" do
		expect(solution_part_1(test_input)).to eq(part_1_expected)
		p "passed 1"
		p solution_part_1(real_input)
	end

	it "Part 2 should pass" do
		# expect(solution_part_2(test_input)).to eq(part_2_expected)
		p solution_part_2(real_input, 50)
	end
end
