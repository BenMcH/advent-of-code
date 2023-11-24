InputLine = Struct.new(
	:type,
	:x_start,
	:x_end,
	:y_start,
	:y_end,
	:z_start,
	:z_end
)

def parse_input_line(line)
	# on x=-20..26,y=-36..17,z=-47..7	
	chars = line.chars
	chars.shift
	type = chars.shift == 'n' ? :on : :off
	tmp = chars.shift until tmp == 'x'

	chars.shift # =
	x_start = chars.take_while{|x| '.' != x}.join.to_i
	chars = chars[1..-1] until chars[0] == '.'
	chars.shift # .
	chars.shift # .
	x_end = chars.take_while{|x| ',' != x}.join.to_i
	chars = chars[1..-1] until chars[0] == '='
	chars.shift # =
	y_start = chars.take_while{|x| '.' != x}.join.to_i
	chars = chars[1..-1] until chars[0] == '.'
	chars.shift # .
	chars.shift # .
	y_end = chars.take_while{|x| ',' != x}.join.to_i
	chars = chars[1..-1] until chars[0] == '='
	chars.shift # =
	z_start = chars.take_while{|x| '.' != x}.join.to_i
	chars = chars[1..-1] until chars[0] == '.'
	chars.shift # .
	chars.shift # .
	z_end = chars.join.to_i

	x_start, x_end = x_end, x_start if x_start > x_end
	y_start, y_end = y_end, y_start if y_start > y_end
	z_start, z_end = z_end, z_start if z_start > z_end

	return InputLine.new(type, x_start, x_end, y_start, y_end, z_start, z_end)
end

example_input = File.read('example.txt').strip.split("\n")

hash = {}
# TODO: Implement overlapping cube detection and counting of on and off cells with map
example_input.each do |line|
	input = parse_input_line(line)
	(input.x_start..input.x_end).each do |x|
		(input.y_start..input.y_end).each do |y|
			(input.z_start..input.z_end).each do |z|
				hash[[x,y,z]] = input.type == :on ? 1 : 0
			end
		end
	end
end

p hash.values.count(1)
