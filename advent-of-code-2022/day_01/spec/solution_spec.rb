test_input = File.read('./test-input.txt').to_s
real_input = File.read('./input')

def calculate_elf_carry_weights(input, top_elves)
	return input.split("\n\n").map{|elf| elf.lines.map(&:to_i).sum}.sort.last(top_elves).sum
end

describe "Day 1" do
	
	it "Part 1" do
		expect(calculate_elf_carry_weights(test_input, 1)).to eq(24_000)
		p "Part 1 #{calculate_elf_carry_weights(real_input, 1)}"
	end

	it "Part 2" do
		expect(calculate_elf_carry_weights(test_input, 3)).to eq(45_000)
		p "Part 2 #{calculate_elf_carry_weights(real_input, 3)}"
	end
end
