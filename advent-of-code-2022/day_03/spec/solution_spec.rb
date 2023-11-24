test_input = File.read('./test-input.txt').lines
real_input = File.read('./input').lines

RuckSack = Struct.new(
	:compartment_1, 
	:compartment_2,
	:all
)

PRIORITIES = ' '.concat(('a'..'z').to_a.join('')).concat(('A'..'Z').to_a.join(''))

def make_ruck(input)
	len = input.length

	a = input[0..len/2-1].split('')
	b = input[len/2..-1].split('')

	return RuckSack.new(a, b, input.split(''))
end

def solution_part_1(input)
	ans = 0
	rucks = input.map do |line|
		ruck = make_ruck(line)

		ans += PRIORITIES.index(ruck.compartment_1.intersection(ruck.compartment_2)[0])
	end

	return ans
end

def find_intersection(input_arr)
	ans, *list = *input_arr

	list.each do |l|
		ans = ans.intersection(l)
	end

	return ans
end

def solution_part_2(input)
	rucks = input.map do |line|
		ruck = make_ruck(line)

		ruck.all
	end

	ans = 0

	rucks.each_slice(3) do |rucs|
		badge = find_intersection(rucs)[0]

		ans += PRIORITIES.index(badge)
	end

	ans
end

describe "Day 3" do
	
	it "Part 1 should pass" do
		expect(solution_part_1(test_input)).to eq(157)

		p "Part 1 #{solution_part_1(real_input)}"
	end

	it "Part 2 should pass" do
		expect(solution_part_2(test_input)).to eq(70)
		
		p "Part 2 #{solution_part_2(real_input)}"
	end
end
