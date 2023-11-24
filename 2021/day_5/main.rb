input = File.read('input.txt').split("\n")

lines = input.map { |line| line.split(' -> ') }

Point = Struct.new(:x, :y)

points = { }

lines.each do |line|
	start, _end = *line

	p1 = Point.new(*start.split(',').map(&:to_i))
	p2 = Point.new(*_end.split(',').map(&:to_i))

	next if  p1.x != p2.x && p1.y != p2.y

	x_diff = p1.x != p2.x

	if x_diff
		min, max = [p1.x, p2.x].sort
		for x in min..max
			loc = "#{x},#{p1.y}"
			points[loc] ||= 0
			points[loc] += 1
		end
	else
		min, max = [p1.y, p2.y].sort
		for y in min..max
			loc = "#{p1.x},#{y}"
			points[loc] ||= 0
			points[loc] += 1
		end
	end
end

p points.values.count { |v| v > 1 }

points = { }

lines.each do |line|
	start, _end = *line

	p1 = Point.new(*start.split(',').map(&:to_i))
	p2 = Point.new(*_end.split(',').map(&:to_i))

	minx, maxx = [p1, p2].sort_by(&:x)
	if minx.x != maxx.x
		for x in (minx.x)..(maxx.x)
			y = minx.y + (x - minx.x) * (p2.y - p1.y) / (p2.x - p1.x)
			loc = "#{x},#{y}"
			points[loc] ||= 0
			points[loc] += 1
		end
	else
		miny, maxy = [p1, p2].sort_by(&:y)
		for y in (miny.y)..(maxy.y)
			x = miny.x + (y - miny.y) * (p2.x - p1.x) / (p2.y - p1.y)
			loc = "#{x},#{y}"
			points[loc] ||= 0
			points[loc] += 1
		end
	end
end

p points.values.count { |v| v > 1 }
