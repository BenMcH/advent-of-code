require 'aoc/helpers'

test_input = File.read('./test-input.txt')
real_input = get_input(2022, 21, File.read('/home/vscode/.adventofcode.session'))

part_1_expected = 152
part_2_expected = 301

Monkey = Struct.new(
	:name,
	:number,
	:symbol,
	:operand,
	:symbol_2
) do
	def to_arr(input)
		if number.nil?
			node_1 = get_node(input, symbol).to_arr(input)
			node_2 = get_node(input, symbol_2).to_arr(input)

			unless contains_human(input, input.find{_1.name == symbol})
				node_1 = eval(to_math(node_1))
			end

			unless contains_human(input, input.find{_1.name == symbol_2})
				node_2 = eval(to_math(node_2))
			end

			[
				node_1,
				operand.to_s,
				node_2
			]
		else
			number
		end
	end
end

def can_eval(input)
	!input.include?('x')
end

def to_math(arr)
	arr.to_s.tr('",', '').tr('[]', '()')
end

def parse_input(input)
	lines(input).map{|line|
		line = line.split(" ")

		val = nil

		name = line[0][0..-2] # Remove :

		if line.length == 2
			value = line[1].to_i

			val = Monkey.new(name, value, nil, nil, nil)
		else
			symbol = line[1]
			operand = line[2]
			symbol_2 = line[3]

			val = Monkey.new(name, nil, symbol, operand.to_sym, symbol_2)
		end

		val
	}
end

def calculate_monkey(input, name, cache = {})
	return cache[name] if cache[name]

	monkey = input.find{_1.name == name}

	if monkey.number.nil?
		cache[name] = [
			calculate_monkey(input, monkey.symbol, cache),
			calculate_monkey(input, monkey.symbol_2, cache)
		].reduce(monkey.operand)
	else
		cache[name] = monkey.number
	end

	return cache[name]
end

def solution_part_1(input)
	input = parse_input(input)

	return calculate_monkey(input, "root")
end

def solution_part_2(input)
	input = parse_input(input)

	root = get_node(input, "root")
	root.operand = '='.to_sym
	get_node(input, "humn").number = 'x'
	left_node = get_node(input, root.symbol)
	right_node = get_node(input, root.symbol_2)

	non_human_node = contains_human(input, left_node) ? right_node : left_node
	human_node = non_human_node == left_node ? right_node : left_node

	value = calculate_monkey(input, non_human_node.name)

	p "#{to_math(human_node.to_arr(input))} = #{value}"
	p "Paste this formula in here to find your answer: https://www.mathpapa.com/equation-solver/"
end

def get_node(input, name)
	input.find{_1.name == name}
end

def contains_human(input, node, name = "humn")
	other_nodes = [node.symbol, node.symbol_2].filter{_1 != nil}.map{|_node| input.find{_1.name == _node}}

	node.name == name || other_nodes.any?{contains_human(input, _1, name)}
end

describe "Day 21" do
	
	it "Part 1 should pass" do
		expect(solution_part_1(test_input)).to eq(part_1_expected)
		p solution_part_1(real_input)
	end

	it "Part 2 should pass" do
		solution_part_2(real_input)
	end
end
