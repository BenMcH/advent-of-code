require 'aoc/helpers'

test_input = File.read('./test-input.txt')
real_input = get_input(2022, 15, File.read('/home/vscode/.adventofcode.session'))

part_1_expected = 26
part_2_expected = 56000011

Sensor = Struct.new(
	:x,
	:y,
	:cb_x,
	:cb_y
) do

	def distance
		(x - cb_x).abs + (y - cb_y).abs
	end

	def safe_row(row)
		width = distance - (row - y).abs
		if width > 0
			ranges = [(x-width)..(x+width)]

			ranges = ranges.flat_map{|r| split_range(r, x)}	if y == row
			ranges = ranges.flat_map{|r| split_range(r, cb_x)}	if cb_y == row
			ranges
		else
			[]
		end
	end

	def points
		[
			[x, y],
			[cb_x, cb_y]
		]
	end
end

def split_range(range, value_to_remove)
	if range.cover?(value_to_remove)
		[
			(range.min..value_to_remove-1),
			(value_to_remove+1)..range.max
		].filter{|r| !r.max.nil?}
	else
		range
	end
end

def parse_input(input)
	lines(input).map {|line| Sensor.new *get_numbers(line)}
end

def cannots(input, row)
	value = input.flat_map {|sensor| sensor.safe_row(row) }

	i = 0
	while i < value.length
		subject = value[i]
		matches = value.filter{|f| overlaps?(f, subject) && f != subject}

		if matches.any?
			value -= matches

			matches.each do |m|
				new_min = [m.min, value[i].min].min
				new_max = [m.max, value[i].max].max

				value[i] = new_min..new_max
			end
		else
			i += 1
		end
	end

	value
end

def solution_part_1(input, row = 10)
	cannots(parse_input(input), row).map(&:count).sum
end

def solution_part_2(input, max_coord = 20)
	input = parse_input(input)
	all_points = input.flat_map(&:points).uniq.group_by(&:last)

	all_points.keys.each do |key|
		all_points[key] = all_points[key].map(&:first)
	end

	(0..max_coord).each do |y|
		ranges = cannots(input, y).sort {|a, b| a.min - b.min}

		max = nil
		ranges.each do |range|
			if max
				if range.min - max == 2 && all_points[y] && all_points[y].include?(max + 1)
					max = range.max
				else
					return (max+1) * 4000000 + y
				end
			else
				max = range.max
			end
		end
	end
end

describe "Day 15" do
	
	it "Part 1 should pass" do
		expect(solution_part_1(test_input)).to eq(part_1_expected)
		p "Passed"
		p solution_part_1(real_input, 2000000)
	end

	it "Part 2 should pass" do
		expect(solution_part_2(test_input)).to eq(part_2_expected)
		p solution_part_2(real_input, 4000000)
	end
end
