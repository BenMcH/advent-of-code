input = File.readlines("./input.txt", chomp: true)

lights = Hash.new(false)

input.each do |line|
	power = line.start_with? "on"
	x_min, x_max, y_min, y_max, z_min, z_max = line.scan(/-?\d+/).map(&:to_i)

	x_min = [x_min, -50].max
	x_max = [x_max, 50].min
	y_min = [y_min, -50].max
	y_max = [y_max, 50].min
	z_min = [z_min, -50].max
	z_max = [z_max, 50].min

	next if x_min > x_max
	next if y_min > y_max
	next if z_min > z_max

	(x_min..x_max).each do |x|
		(y_min..y_max).each do |y|
			(z_min..z_max).each do |z|
				lights[[x, y, z]] = power
			end
		end
	end
end

p lights.values.count(true)
