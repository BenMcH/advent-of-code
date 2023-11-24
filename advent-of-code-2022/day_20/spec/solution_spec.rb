require 'aoc/helpers'

test_input = File.read('./test-input.txt')
real_input = get_input(2022, 20, File.read('/home/vscode/.adventofcode.session'))

part_1_expected = 3
part_2_expected = 1623178306

Entry = Struct.new(
	:index,
	:offset
)

def parse_input(input)
	lines(input).map.with_index{ |l, i| Entry.new(i, l.to_i) }
end

def decrypt_file(input, iterations = 1)
	iterations.times do |c|
		input.count.times do |i|
			v = input.find{_1.index == i}
			index = input.index(v)
			new_index = (index + v.offset) 

			next if index == new_index
			new_index %= input.length-1

			input.delete_at(index)
			input.insert(new_index, v)
		end
		input = input.rotate until input[0].offset == 0
	end

	input = input.map(&:offset)
end

def solution_part_1(input)
	input = parse_input(input)
	ans = decrypt_file(input)

	zero_index = ans.index(0)
	[1000, 2000, 3000].map{ans[(_1 + zero_index) % ans.length]}.reduce(:+)
end

def solution_part_2(input)
	input = parse_input(input).map{_1.offset *= 811589153; _1}

	ans = decrypt_file(input, 10)

	zero_index = ans.index(0)
	[1000, 2000, 3000].map{ans[(_1 + zero_index) % ans.length]}.reduce(:+)
end

describe "Day 20" do
	
	it "Part 1 should pass" do
		expect(solution_part_1(test_input)).to eq(part_1_expected)
		p "passed"
		p solution_part_1(real_input)
	end

	it "Part 2 should pass" do
		expect(solution_part_2(test_input)).to eq(part_2_expected)
		p "passed"
		p solution_part_2(real_input)
	end
end
