require 'aoc/helpers'

test_input = File.read('./test-input.txt')
real_input = get_input(2022, 23, File.read('/home/vscode/.adventofcode.session'))

part_1_expected = 110
part_2_expected = 20

def parse_input(input)
	board = {}
	lines(input).each.with_index do |line, row|
		characters(line).each.with_index do |char, col|
			board[[row, col]] = ELF if char == ELF
		end
	end

	board
end

ELF = '#'

def step(board, elf, round)
	elf_y = elf[0]
	elf_x = elf[1]
	top = (-1..1).count{ board[[elf_y - 1, elf_x + _1]] == ELF }
	bottom = (-1..1).count{ board[[elf_y + 1, elf_x + _1]] == ELF }
	left = (-1..1).count{ board[[elf_y + _1, elf_x - 1]] == ELF }
	right = (-1..1).count{ board[[elf_y + _1, elf_x + 1]] == ELF }

	conditions = [
		[top, [elf_y-1, elf_x]],
		[bottom, [elf_y+1, elf_x]],
		[left, [elf_y, elf_x-1]],
		[right, [elf_y, elf_x+1]],
	]

	if [top + bottom + left + right].sum == 0
		return elf
	end

	round.times do
		conditions = conditions.rotate
	end

 	conditions.each do |cond|
		if cond[0] == 0
			return cond[1] 
		end
	end

	return elf
end

def print_board(board)
	keys = board.keys
	min_x, max_x = keys.map(&:last).minmax
	min_y, max_y = keys.map(&:first).minmax

	puts '-'*20
	(min_y..max_y).each do |y|
		(min_x..max_x).each do |x|
			print (board[[y, x]] || '.')
		end
		puts
	end
end

ElfStep = Struct.new(
	:old_loc,
	:new_loc
)

def round(board, round = 0)
	elves = board.keys

	elves = elves.map{ElfStep.new(_1, step(board, _1, round))}

	counts = elves.map(&:new_loc).tally

	new_board = {}
	elves.each do |elf|
		count_same_loc = counts[elf.new_loc]
		if count_same_loc > 1
			new_board[elf.old_loc] = ELF
			next
		end

		new_board[elf.new_loc] = ELF
	end

	new_board
end

def solution_part_1(input)
	board = parse_input(input)

	10.times do |i|
		board = round(board, i)
	end

	keys = board.keys
	min_x, max_x = keys.map(&:last).minmax
	min_y, max_y = keys.map(&:first).minmax

	count = 0
	(min_y..max_y).each do |y|
		(min_x..max_x).each do |x|
			count += 1 unless board[[y, x]] == ELF
		end
	end

	count
end

def solution_part_2(input)
	board = parse_input(input)

	round = 0
	loop do |i|
		new_board = round(board, round)
		round += 1

		break if new_board == board
		board = new_board
	end

	round
end

describe "Day 23" do
	it "Part 1 should pass" do
		expect(solution_part_1(test_input)).to eq(part_1_expected)
		p solution_part_1(real_input)
	end

	it "Part 2 should pass" do
		expect(solution_part_2(test_input)).to eq(part_2_expected)
		p solution_part_2(real_input)
	end
end
