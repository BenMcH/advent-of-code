require 'digest'

input = File.read("./resources/input-17").strip

Position = Struct.new(:x, :y)

pos = Position.new(0, 0)

q = [[pos, input]]

open_chars = ["b", "c", "d", "e", "f"]
print_path = true
max_len = 0

until q.empty?
	# p q
	cur = q.shift

	directions = Digest::MD5.hexdigest(cur[1])
	
	# p directions
	
	up = directions[0]
	down = directions[1]
	left = directions[2]
	right = directions[3]
	_pos = cur[0]

	if _pos.x == 3 && _pos.y == 3
		puts cur[1].chars.last(cur[1].length - input.length).join if print_path
		print_path = false
		max_len = [max_len, cur[1].length - input.length].max

		next
	end
	
	if open_chars.include?(up) && _pos.y > 0
		q << [Position.new(_pos.x, _pos.y - 1), cur[1] + "U"]
	end
	
	if open_chars.include?(down) && _pos.y < 3
		q << [Position.new(_pos.x, _pos.y + 1), cur[1] + "D"]
	end
	
	if open_chars.include?(left) && _pos.x > 0
		q << [Position.new(_pos.x - 1, _pos.y), cur[1] + "L"]
	end
	
	if open_chars.include?(right) && _pos.x < 3
		q << [Position.new(_pos.x + 1, _pos.y), cur[1] + "R"]
	end
	
end

puts max_len
