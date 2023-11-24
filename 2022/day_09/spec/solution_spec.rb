test_input = File.read('./test-input.txt')
real_input = File.read('./input')

part_1_expected = 13
part_2_expected = 36

def move_tail(head, tail)
	if head[0] == tail[0]
		if (head[1] - tail[1]).abs == 2
			tail[1] = head[1] > tail[1] ? head[1] - 1 : head[1] + 1
		end
	elsif head[1] == tail[1]
		if (head[0] - tail[0]).abs == 2
			tail[0] = head[0] > tail[0] ? (head[0] - 1) : (head[0] + 1)
		end
	elsif (head[0] - tail[0]).abs == 2 || (head[1] - tail[1]).abs == 2
		row_add = head[0] > tail[0] ? 1 : -1
		col_add = head[1] > tail[1] ? 1 : -1

		tail[0] += row_add
		tail[1] += col_add
	end
end

def move(movement, head, tails, tail_pos)
	dir, length = *movement
	length = length.to_i

	length.times do
		case dir
		when 'R' then head[0] += 1 
		when 'L' then head[0] -= 1 
		when 'U' then head[1] += 1 
		when 'D' then head[1] -= 1 
		end

		
		[head, *tails].each_cons(2).with_index do |pair, i|
			h, t = *pair

			move_tail(h, t)

			tail_pos << t.dup if i == tails.length - 1
		end
end

	head
end

def solution_part_1(input)
	lines = input.split("\n").map(&:split)

	head = [0, 0]
	tail = [0, 0]

	tail_pos = []

	lines.each do |l|
		move(l, head, [tail], tail_pos)	
	end

	return tail_pos.uniq.count
end

def solution_part_2(input)
	lines = input.split("\n").map(&:split)

	head = [0, 0]
	tails = []
	9.times { tails << [0, 0] }

	tail_pos = []

	lines.each do |l|
		move(l, head, tails, tail_pos)	
	end

	return tail_pos.uniq.count
end

describe "Day 9" do
	
	it "Part 1 should pass" do
		expect(solution_part_1(test_input)).to eq(part_1_expected)
		p solution_part_1(real_input)
	end

	it "Part 2 should pass" do
		test_input = "
			R 5
			U 8
			L 8
			D 3
			R 17
			D 10
			L 25
			U 20
		".strip
		expect(solution_part_2(test_input)).to eq(part_2_expected)
		p solution_part_2(real_input)
	end
end
