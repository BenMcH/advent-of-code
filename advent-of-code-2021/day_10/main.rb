
def line_is_balanced(line)
	stack = []
	score = 0
	openers = "({<["
	closers = ")}>]"
	line.each.with_index do |char, i|
		if openers.include?(char)
			stack.push(closers[openers.index(char)])
		else
			expected = stack.pop()
			if expected != char
				score += case char
				when ')' then 3
				when ']' then 57
				when '}' then 1197
				when '>' then 25137
				end

				stack.push(expected)
				return [stack, score, char]
			end
		end
	end

	return [stack.reverse, score, nil]
end

def part_1(input)
	score = 0
	input.split("\n").map { |line| line.split('') }.each do |line|
		stack, inner_score, char = line_is_balanced(line)
		score += inner_score
	end

	score
end

example_input = File.read('example.txt')
ex_output = part_1(example_input)

throw Exception.new("Part 1 is not 26397, got: #{ex_output}" ) if ex_output != 26397

input = File.read('input.txt')

p part_1(input)

def part_2(input)
	score_map = {
		')': 1,
		']': 2,
		'}': 3,
		'>': 4,
	}
	scores = []
	input.split("\n").map { |line| line.split('') }.each do |line|
		stack, inner_score, char = line_is_balanced(line)
		if !char
			scores << stack.reduce(0) do |acc, val|
				acc * 5 + score_map[val.to_sym]
			end
		end
	end

	scores.sort[scores.length / 2]
end

ex_output = part_2(example_input)
throw Exception.new("Part 2 is not 288957, got: #{ex_output}") if ex_output != 288957

p part_2(input)
