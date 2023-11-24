test_input = File.read('./test-input.txt')
real_input = File.read('./input')

def solution_part_1(input)
	answer = 0
	total_cycles = 1
	x = 1
	input.split("\n").flat_map{|line| line.start_with?("addx") ? ['noop', line] : [line]}.each.with_index do |line, i|
		if line.start_with? 'addx'
			x += line.split(' ')[1].to_i
		end
		total_cycles += 1

		if [20, 60, 100, 140, 180, 220].include?(total_cycles)
			answer += (total_cycles * x)
		end

	end
	return answer
end

def solution_part_2(input)
	total_cycles = 0
	x = 1
	arr = input.split("\n").flat_map{|line| line.start_with?("addx") ? ['noop', line] : [line]}
	puts ""
	arr.each.with_index do |line, i|
		if [x-1, x, x+1].any? { |a| a == (total_cycles % 40) }
			print "X"
		else
			print "."
		end
		if line.start_with? 'addx'
			x += line.split(' ')[1].to_i
		end
		total_cycles += 1

		print "\n" if total_cycles % 40 == 0
	end
end

describe "Day 10" do
	
	it "Part 1 should pass" do
		expect(solution_part_1(test_input)).to eq(13140)
		p solution_part_1(real_input)
	end

	it "Part 2 should pass" do
		solution_part_2(test_input)
		solution_part_2(real_input)
	end
end
