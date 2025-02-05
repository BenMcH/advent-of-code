num = File.read('./resources/input-13').to_i

Position = Struct.new(:y, :x) do
	def neighbors
		[
			Position.new(y - 1, x),
			Position.new(y + 1, x),
			Position.new(y, x - 1),
			Position.new(y, x + 1)
		]
	end
end

map = Hash.new do |h,k|
	if k.x < 0 || k.y < 0
		h[k] = '#'
	else
		y = k.y
		x = k.x

		val = x*x + 3*x + 2*x*y + y + y*y
		val += num
		val = val.to_s(2).chars

		h[k] = val.count('1') % 2 == 0 ? '.' : '#'
	end
end

loc_map = Hash.new(Float::INFINITY)

target = Position.new(39, 31)

q = [Position.new(1, 1)]
loc_map[Position.new(1, 1)] = 0
until q.empty?
	cur = q.shift
	cur.neighbors.each do |n|
		next if map[n] == '#'
		next if loc_map[n] != Float::INFINITY
		
		loc_map[n] = loc_map[cur] + 1
		q << n
	end

	break if loc_map[target] < Float::INFINITY
end

p loc_map[target]

q = [Position.new(1, 1)]
loc_map[Position.new(1, 1)] = 0
until q.empty?
	cur = q.shift
	next if loc_map[cur] > 50
	cur.neighbors.each do |n|
		next if map[n] == '#'
		next if loc_map[n] != Float::INFINITY
		
		loc_map[n] = loc_map[cur] + 1
		q << n
	end
end

p loc_map.filter { |k, v| v <= 50 }.count
