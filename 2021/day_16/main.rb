def decode_packet(packet)
	version = packet[0...3].to_i(2)
	type_id = packet[3...6].to_i(2)
	rest = packet[6..-1]

	header = {
		version: version,
		type_id: type_id
	}

	if type_id == 4
		value = ''

		loop do
			continue_bit = rest[0]
			value << rest[1...5]
			rest = rest[5..-1]

			break unless continue_bit == '1'
		end

		header[:children] = value.to_i(2)
	else # Operator Packet
		length_type_id = rest[0].to_i
		rest = rest[1..-1]
		header[:children] = []

		if length_type_id == 0
			bits = rest[0...15].to_i(2)
			rest = rest[15..-1]

			sub_packets = rest[0...bits]
			rest = rest[bits..-1]

			while sub_packets.length > 0
				pack, sub_packets = decode_packet(sub_packets)
				header[:children] << pack
			end
		else
			number_of_sub_packets = rest[0...11].to_i(2)
			rest = rest[11..-1]

			while number_of_sub_packets > 0
				sub_packets, rest = decode_packet(rest)
				header[:children] << sub_packets
				number_of_sub_packets -= 1
			end
		end
	end

	return header, rest
end

def add_versions(result)
	value = result[:version]

	if result[:children] && result[:children].is_a?(Array)
		result[:children].each do |child|
			value += add_versions(child)
		end
	end

	value
end

def part_1(input)
	add_versions(decode_packet(input)[0])
end

def read_input(data)
	data.strip.split('').map {|char| char.to_i(16).to_s(2).rjust(4, '0')}.join
end

example_packets = read_input('A0016C880162017C3686B18A3D4780')

ex_output = part_1(example_packets)

throw Exception.new("Part 1 is not 31, got: #{ex_output}" ) if ex_output != 31

input_packets = read_input(File.read('input.txt'))

p part_1(input_packets)

def get_value(cell)
	if cell[:type_id] == 4
		return cell[:children]
	end

	case cell[:type_id]
	when 0 then cell[:children].map {|child| get_value(child)}.sum
	when 1 then cell[:children].map {|child| get_value(child)}.reduce(:*)
	when 2 then cell[:children].map {|child| get_value(child)}.min
	when 3 then cell[:children].map {|child| get_value(child)}.max
	when 5 then get_value(cell[:children].first) > get_value(cell[:children][1]) ? 1 : 0
	when 6 then get_value(cell[:children].first) < get_value(cell[:children][1]) ? 1 : 0
	when 7 then get_value(cell[:children].first) == get_value(cell[:children][1]) ? 1 : 0
	end
end

def part_2(input)
	tree = decode_packet(input)[0]
	require 'json'
	File.write('output.json', tree.to_json)

	get_value(tree)
end

example_packets = read_input('9C0141080250320F1802104A08')

ex_output = part_2(example_packets)
throw Exception.new("Part 2 is not 1, got: #{ex_output}") if ex_output != 1

p part_2(input_packets)
