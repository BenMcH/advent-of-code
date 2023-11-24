require "net/http"
require 'aoc/helpers'

test_input = File.read('./test-input.txt')
real_input = Aoc::Helpers.get_input(2022, 11, File.read("/home/vscode/.adventofcode.session"))

part_1_expected = 10605
part_2_expected = 2713310158

Monkey = Struct.new(
	:starting_items,
	:operation,
	:test,
	:true_action,
	:false_action,
	keyword_init: true
)

def parse_monkey(monkey_input)
	id, starting, operation, test_cond, true_action, false_action = *monkey_input.split("\n").map(&:strip)

	operation = operation.split("=")[1]

	operand, action, operand_1 = operation.split(" ")

	Monkey.new(
		starting_items: starting.scan(/\d+/).map(&:to_i),
		operation: [operand, action, operand_1],
		test: test_cond.scan(/\d+/)[0].to_i,
		true_action: true_action.scan(/\d+/)[0].to_i,
		false_action: false_action.scan(/\d+/)[0].to_i
	)
end

def inspect_item(monkey, extra_worry, max_test)
	worry = monkey.starting_items[0]

	operand, action, operand_1 = monkey.operation[0], monkey.operation[1], monkey.operation[2]

	operand = worry if operand == "old"
	operand_1 = worry if operand_1 == "old"

	worry = operand.to_i + operand_1.to_i if action == "+"
	worry = operand.to_i * operand_1.to_i if action == "*"
	worry = worry % max_test
	worry = worry.div(3) unless extra_worry


	monkey.starting_items[0] = worry
end

def test_item(monkey)
	monkey["#{monkey.starting_items[0] % monkey.test == 0}_action"]
end

def round(monkeys, extra_worry = true)
	max_test = monkeys.map(&:test).reduce(1){|acc, v| v * acc}
	operations = []

	monkeys.each do |monke|
		operations << 0
		until monke.starting_items.length == 0
			inspect_item(monke, extra_worry, max_test)
			operations[-1] += 1
			next_monke = test_item(monke)

			monkeys[next_monke].starting_items << monke.starting_items[0]
			monke.starting_items = monke.starting_items[1..-1]
		end
	end

	operations
end

def solution_part_1(input)
	monkeys = input.strip.split("\n\n").map{|m| parse_monkey(m)}

	operations = nil

	20.times do
		ops = round(monkeys, false)

		if operations
			ops.each_with_index do |val, i|
				operations[i] += val
			end
		else
			operations = ops
		end
	end

	operations.sort.last(2).reduce(1) {|acc, val| acc * val}
end

def solution_part_2(input)
	monkeys = input.strip.split("\n\n").map{|m| parse_monkey(m)}

	operations = nil

	10_000.times do |i|

		ops = round(monkeys, true)

		if operations
			ops.each_with_index do |val, i|
				operations[i] += val
			end
		else
			operations = ops
		end
	end

	operations.sort.last(2).reduce(1) {|acc, val| acc * val}
end

describe "Day 11" do
	
	it "Part 1 should pass" do
		expect(solution_part_1(test_input)).to eq(part_1_expected)
		p solution_part_1(real_input)
	end

	it "Part 2 should pass" do
		expect(solution_part_2(test_input)).to eq(part_2_expected)
		p solution_part_2(real_input)
	end
end
