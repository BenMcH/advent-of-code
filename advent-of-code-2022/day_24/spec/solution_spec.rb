require 'aoc/helpers'
require 'set'

test_input = File.read('./test-input.txt')
real_input = get_input(2022, 24, File.read('/home/vscode/.adventofcode.session'))

part_1_expected = 18
part_2_expected = 54

AVALANCHE_DIRECTIONS = {
	'^': [-1, 0],
	'v': [1, 0],
	'<': [0, -1],
	'>': [0, 1],
}
Avalanche = Struct.new(
	:direction,
	:x,
	:y,
	:board_width,
	:board_height
) do
	def step
		self.y, self.x = *add_number_arrays([self.y, self.x], self.direction)

		self.y = board_height - 2 if self.y == 0
		self.y = 1 if self.y == board_height - 1
		self.x = board_width - 2 if self.x == 0
		self.x = 1 if self.x == board_width - 1
	end

	def to_sym
		AVALANCHE_DIRECTIONS.find{_2 == self.direction}[0].to_sym
	end

	def to_s
		"#{y},#{x}"
	end
end

def parse_input(input)
	avs = []
	l = lines(input)
	l.each_with_index do |line, row|
		chars = characters line
		chars.each_with_index do |ch, col|
			ch = ch.to_sym
			if AVALANCHE_DIRECTIONS.keys.include?(ch)
				avs << Avalanche.new(
					AVALANCHE_DIRECTIONS[ch],
					col,
					row,
					line.length,
					l.length
				)
			end
		end
	end

	avs
end

Attempt = Struct.new(:x, :y, :time) do
	def moves
		start = self.dup
		start.time += 1

		up = start.dup
		up.y -= 1

		right = start.dup
		right.x += 1

		down = start.dup
		down.y += 1

		left = start.dup
		left.x -= 1

		[start, up, right, down, left]
	end
end

def search(input, states, start_x, start_y, goal_x, goal_y, time = 0)
	queue = [ Attempt.new(start_x, start_y, time) ]
	visited = queue.dup.to_set

	while queue.any?
		item = queue.shift

		moves = item.moves

		moves.each do |move|
			# p move
			return move.time if move.x == goal_x && move.y == goal_y

			state_index = move.time % states.length
			out_of_bounds_x = move.x < 0 || move.x >= input[0].length
			out_of_bounds_y = move.y < 0 || move.y >= input.length
			has_avalanche = states[state_index].include?("#{move.y},#{move.x}")
			has_been_visited = visited.include?("#{move.y},#{move.x},#{move.time}")

			next if out_of_bounds_x || out_of_bounds_y || has_avalanche || has_been_visited || input[move.y][move.x] == '#'

			visited.add("#{move.y},#{move.x},#{move.time}")
			queue.push(move);
		end
	end
end

def solution_part_1(input)
	l = lines(input).map{characters(_1)}
	input = parse_input(input)

	states = []

	l.length.times do
		l[0].length.times do
			states << input.map(&:to_s).to_set

			input.each(&:step)
		end
	end

	start_x, start_y = 1, 0
	target_x, target_y = l[0].length - 2, l.length - 1

	search(l, states, start_x, start_y, target_x, target_y)
end

def solution_part_2(input)
	l = lines(input).map{characters(_1)}
	input = parse_input(input)

	states = []

	l.length.times do
		l[0].length.times do
			states << input.map(&:to_s).to_set

			input.each(&:step)
		end
	end

	start_x, start_y = 1, 0
	target_x, target_y = l[0].length - 2, l.length - 1

	t1 = search(l, states, start_x, start_y, target_x, target_y)
	t2 = search(l, states, target_x, target_y, start_x, start_y, t1)
	t3 = search(l, states, start_x, start_y, target_x, target_y, t2)

	t3
end

describe "Day 24" do
	
	it "Part 1 should pass" do
		expect(solution_part_1(test_input)).to eq(part_1_expected)
		p "Passed 1"
		p solution_part_1(real_input)
	end

	it "Part 2 should pass" do
		expect(solution_part_2(test_input)).to eq(part_2_expected)
		p "Passed 2"
		p solution_part_2(real_input)
	end
end
