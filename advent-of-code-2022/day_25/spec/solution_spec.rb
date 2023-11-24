require 'aoc/helpers'

test_input = File.read('./test-input.txt')
real_input = get_input(2022, 25, File.read('/home/vscode/.adventofcode.session'))

part_1_expected = "2=-1=0"
part_2_expected = 2

SNAFU = {
	'2' => 2,
	'1' => 1,
	'0' => 0,
	'-' => -1,
	'=' => -2,
}

TestCase = Struct.new(
	:snafu,
	:dec
)

def snafu_to_dec(snafu)
	ufans = snafu.reverse

	total = 0

	ufans.chars.each_with_index do |char, index|
		power = 5 ** index
		total += (power * SNAFU[char])
	end

	total
end

def convert_common_nums_to_snafu(num)
	case num
	when 3 then "1="
	else num.to_s
	end
end

def dec_to_snafu(dec)
	# dec.to_s(5).gsub('3', '1=').gsub(/0?4/, '1-')
	total = []

	power = 0

	while 5 ** power <= dec
		power += 1
	end

	index = 0
	while power >= 0
		dec_s = dec.to_s

		d = 5**power
		d1 = (dec / d.to_f).floor

		total.push d1

		dec = dec % d
		power -= 1
	end

	total.unshift 0

	until total.all? {_1 < 3}
		(total.length).times do
			index = _1
			val = total[index]

			if val >= 3
				total[index] = -5 + val
				total[index-1] += 1
			end
		end
	end

	p total
	snafu = total.map { SNAFU.to_a.rassoc(_1)[0] }.join("")
	until snafu[0] != '0'
		snafu = snafu.delete_prefix('0')
	end

	snafu
end

def solution_part_1(input)
	dec = lines(input).map{snafu_to_dec(_1)}.sum

	dec_to_snafu(dec)
end

def solution_part_2(input)
	return 2
end

describe "Day 25" do

	TEST_CASES = [
		TestCase.new("1=11-2", 2022),
		TestCase.new("1", 1),
		TestCase.new("2", 2),
		TestCase.new("1=", 3),
		TestCase.new("1-", 4),
		TestCase.new("10", 5),
		TestCase.new("11", 6),
		TestCase.new("12", 7),
		TestCase.new("2=", 8),
		TestCase.new("2-", 9),
		TestCase.new("20", 10),
		TestCase.new("1=0", 15),
		TestCase.new("1-0", 20),
		TestCase.new("1-0---0", 12345),
		TestCase.new("1121-1110-1=0", 314159265),
	]

	it "translates snafu to decimal" do
		TEST_CASES.each {
			expect(snafu_to_dec(_1.snafu)).to eq(_1.dec)
		}
	end

	it "translates decimal to snafu" do
		TEST_CASES.each {
			expect(dec_to_snafu(_1.dec)).to eq(_1.snafu)
		}
	end
	
	it "Part 1 should pass" do
		expect(solution_part_1(test_input)).to eq(part_1_expected)
		p "part 1 passed"
		p solution_part_1(real_input)
	end

	it "Part 2 should pass" do
		expect(solution_part_2(test_input)).to eq(part_2_expected)
		p solution_part_2(real_input)
	end
end
