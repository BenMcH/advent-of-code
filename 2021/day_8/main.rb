
@unique_patterns = {
	2 => 1,
	4 => 4,
	3 => 7,
	7 => 8
}

def part_1(input)
	rows = input.split("\n")
	rows.reduce(0) do |acc, row|
		input, i = row.split(' | ')

		acc + i.split.map do |j|
			@unique_patterns[j.length] ? 1 : 0
		end.sum
	end
end


example_input = File.read('example.txt')
ex_output = part_1(example_input)

throw Exception.new("Part 1 is not 26, got: #{ex_output}" ) if ex_output != 26

input = File.read('input.txt')

p part_1(input)

def part_2(input)
	rows = input.split("\n")

	rows.reduce(0) do |acc, row|
		input, output = row.split(' | ')

		wire_mappings = {}

		inputs = input.split.map do |str|
			str = str.split('').sort.join
			number = @unique_patterns[str.length]

			if number
				wire_mappings[number] = str
			end

			str
		end

		inputs.each do |i|
			if i.length == 6
				if wire_mappings[1].split('').all?{|j| i.include?(j)}
					if wire_mappings[4].split('').all?{|j| i.include?(j)}
						wire_mappings[9] = i
					else
						wire_mappings[0] = i
					end
				else
					wire_mappings[6] = i
				end
			elsif i.length == 5
				count = wire_mappings[4].split('').count { |j| !i.include?(j) }

				if wire_mappings[7].split('').all? { |j| i.include?(j) }
					wire_mappings[3] = i
				elsif count == 1
					wire_mappings[5] = i
				else
					wire_mappings[2] = i
				end
			end
		end

		acc + output.split.map do |num|
			wm = wire_mappings.rassoc(num.split('').sort.join)

			wm ? wm[0] : 0
		end.join.to_i
	end
end

ex_output = part_2(example_input)
throw Exception.new("Part 2 is not 61229, got: #{ex_output}") if ex_output != 61229

p part_2(input)
