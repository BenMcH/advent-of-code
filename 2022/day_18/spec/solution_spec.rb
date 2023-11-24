require 'aoc/helpers'

test_input = File.read('./test-input.txt')
real_input = get_input(2022, 18, File.read('/home/vscode/.adventofcode.session'))

part_1_expected = 64
part_2_expected = 58

BORDER_MATRICES = [
	[1,0,0],
	[0,1,0],
	[0,0,1],
	[-1,0,0],
	[0,-1,0],
	[0,0,-1],
]

Cube = Struct.new(
	:x,
	:y,
	:z
)

def parse_input(input)
	lines(input).map{|line| Cube.new(*get_numbers(line))}
end

def count_surface_area(cubes, part_2 = false)
	map = {}
	max = 0
	count = 0

	cubes.each do |cube|
		key = [cube.x, cube.y, cube.z]

		m = key.max
		max = m if m > max

		map[key] = true
	end

	cubes.each do |cube|
		BORDER_MATRICES.each do |direction|
			new_loc = [cube.x, cube.y, cube.z]

			new_loc = add_number_arrays(new_loc, direction)

			unless map[new_loc]
				if !part_2 || !surrounded(map, new_loc, max)
					count += 1
				else
					fill(map, new_loc)
				end
			end
		end
	end

	return count
end

def fill(map, loc)
	map[loc] = true

	BORDER_MATRICES.each do |direction|
		new_loc = add_number_arrays(loc, direction)

		fill(map, new_loc) if map[new_loc].nil?
	end
end

def surrounded(map, location, max, visited = [])
	BORDER_MATRICES.all? do |direction|
		new_loc = add_number_arrays(location, direction)

		return false if new_loc.any? {|v| v < 0 || v > max}

		s = map[new_loc] || visited.include?(new_loc)
		visited << new_loc unless s
		s || surrounded(map, new_loc, max, visited)
	end
end

def solution_part_1(input)
	cubes = parse_input(input)

	count_surface_area(cubes)
end

def solution_part_2(input)
	cubes = parse_input(input)

	return count_surface_area(cubes, true)
end

describe "Day 18" do
	
	it "Part 1 should pass" do
		expect(solution_part_1(test_input)).to eq(part_1_expected)
		p solution_part_1(real_input)
	end

	it "Part 2 should pass" do
		expect(solution_part_2(test_input)).to eq(part_2_expected)
		p solution_part_2(real_input)
	end
end
