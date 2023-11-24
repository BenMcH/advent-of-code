require 'aoc/helpers'

test_input = File.read('./test-input.txt')
real_input = get_input(2022, 12, File.read("/home/vscode/.adventofcode.session"))

part_1_expected = 31
part_2_expected = 29

def parse_board(input)
	input = lines(input).map{|l| characters(l).map{|letter| is_upper(letter) ? letter : ALPHABET.index(letter)}}

	starting_location = nil
	ending_location = nil
	input.each_with_index do |row, i|
		row.each_with_index do |col, j|
			if col == 'S'
				input[i][j] = 0
				starting_location = [i,j]
			elsif col == 'E'
				input[i][j] = 25
				ending_location = [i,j]
			end
		end
	end

	[input, starting_location, ending_location]
end

def walk(map, location, destination, part_2 = false)
	inf = 999999999
	neighbors = [[0, location]]

	distance_map = {}

	until neighbors.empty?
		distance, loc = *neighbors.pop

		distance_map[loc] ||= inf

		next if distance_map[loc] <= distance

		distance_map[loc] = distance

		row, col = *loc

		new_dist = distance+1
		if row > 0 && map[row-1][col] <= map[row][col] + 1
			nloc = [row-1, col]
			if !distance_map[nloc] || distance_map[nloc] > new_dist
				neighbors << [new_dist, nloc]
				neighbors[-1][0] = 0 if map[nloc[0]][nloc[1]] == 0 && part_2
			end
		end
		if row+1 < map.length && map[row+1][col] <= map[row][col]+1
			nloc = [row+1, col]
			if !distance_map[nloc] || distance_map[nloc] > new_dist
				neighbors << [new_dist, nloc] 
				neighbors[-1][0] = 0 if map[nloc[0]][nloc[1]] == 0 && part_2
			end
		end
		if col > 0 && map[row][col-1] <= map[row][col]+1
			nloc = [row, col - 1]
			if !distance_map[nloc] || distance_map[nloc] > new_dist
				neighbors << [new_dist, nloc] 
				neighbors[-1][0] = 0 if map[nloc[0]][nloc[1]] == 0 && part_2
			end
		end
		if col+1 < map[0].length && map[row][col+1] <= map[row][col]+1
			nloc = [row, col + 1]
			if !distance_map[nloc] || distance_map[nloc] > new_dist
				neighbors << [new_dist, nloc] 
				neighbors[-1][0] = 0 if map[nloc[0]][nloc[1]] == 0 && part_2
			end
		end
	end

	distance_map[destination] && distance_map[destination] || inf
end

def solution_part_1(input)
	input, starting_location, ending_location = *parse_board(input)

	return walk(input, starting_location, ending_location)
end

def solution_part_2(input)
	input, starting_location, ending_location = *parse_board(input)

	return walk(input, starting_location, ending_location, true)
end

describe "Day 12" do
	
	it "Part 1 should pass" do
		expect(solution_part_1(test_input)).to eq(part_1_expected)
		p solution_part_1(real_input)
	end

	it "Part 2 should pass" do
		expect(solution_part_2(test_input)).to eq(part_2_expected)
		p solution_part_2(real_input)
	end
end
