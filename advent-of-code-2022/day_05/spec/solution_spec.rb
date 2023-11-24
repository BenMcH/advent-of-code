test_input = File.read('./test-input.txt').split("\n\n")
real_input = File.read('./input').split("\n\n")

def parse_map(input)
	map = input[0].lines

	map = map[0..-2].map do |row|
		chars = row.split ""
		cols = []

		i = -3
		cols << chars[i+=4] while i < chars.length

		cols
	end.transpose.map do |row|
		row.filter {|val| val != " "}.reverse
	end
end

def move(stacks, number, from, to, stable = false)
	new_stack = []
	number.times do
		val = stacks[from-1].pop

		new_stack.push val
	end

	if stable
		new_stack.reverse!
	end

	stacks[to-1].concat(new_stack)
end

def solve(input, stable = false)
	map = parse_map(input)

	input[1].lines.each do |move|
		instructions = move.split " "

		move(map, instructions[1].to_i, instructions[3].to_i, instructions[5].to_i, stable)
	end

	map.map(&:pop).join('')
end

def solution_part_1(input)
	solve(input, false)	
end

def solution_part_2(input)
	solve(input, true)
end

describe "Day 5" do
	
	it "Part 1 should pass" do

		expect(solution_part_1(test_input)).to eq('CMZ')

		p "Part 1: #{solution_part_1(real_input)}"
	end

	it "Part 2 should pass" do
		expect(solution_part_2(test_input)).to eq('MCD')

		p "Part 2: #{solution_part_2(real_input)}"
	end
end
