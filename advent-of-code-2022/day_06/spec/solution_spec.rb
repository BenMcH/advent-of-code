test_input = File.read('./test-input.txt')
real_input = File.read('./input')

def locate_message(input, length)
	input = input.strip.chars
	input.length.times do |i|
		next if i < length-1
		
		arr = []
		length.times { |j| arr << input[i-j] }

		return i + 1 if arr.uniq == arr
	end
end

def solution_part_1(input)
	return locate_message(input, 4)
end

def solution_part_2(input)
	return locate_message(input, 14)
end

describe "Day 6" do
	
	it "Part 1 should pass" do
		expect(solution_part_1(test_input)).to eq(7)

		p "Part 1: #{solution_part_1(real_input)}"
	end

	it "Part 2 should pass" do
		expect(solution_part_2(test_input)).to eq(19)

		p "Part 1: #{solution_part_2(real_input)}"
	end
end
