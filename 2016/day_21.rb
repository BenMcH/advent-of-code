input = File.readlines('./resources/input-21').map(&:strip)

starting_text = 'abcdefgh'.freeze

def scramble(text, input)
	text = text.dup
	input.each do |line|
		type, *args = line.split(' ')
		
		case type
		when "swap"
			if args[0] == "letter"
				a = args[1]
				a = text.find_index(a)
				b = args[-1]
				b = text.find_index(b)
				
				text[a], text[b] = text[b], text[a]
			elsif args[0] == "position"
				a = args[1].to_i
				b = args[-1].to_i
				
				text[a], text[b] = text[b], text[a]
			else
				raise "Unknown argument: #{args[0]}"
			end
		when "move"
			if args[0] == "position"
				a = args[1].to_i
				b = args[-1].to_i
				a = text.delete_at(a)
				text.insert(b, a)
			else
				raise "Unknown argument: #{args[0]}"
			end
		when "rotate"
			rotations = 0
			if args[0] == "based"
				a = text.find_index(args[-1])	
				rotations = 1 + a
				rotations += 1 if a >= 4
			elsif args[0] == "left"
				rotations = -1 * args[1].to_i
			elsif args[0] == "right"
				rotations = 1 * args[1].to_i
			else
				raise "Unknown rotate argument: #{args[0]}"
			end
			
			text = text.reverse if rotations > 0
			text = text.rotate(rotations.abs)
			text = text.reverse if rotations > 0
		when "reverse"
			a = args[1].to_i
			b = args[-1].to_i
			text[a..b] = text[a..b].reverse
		else
			raise "Unknown type: #{type} #{args}"
		end
	end
	
	text.join
end

puts scramble(starting_text.chars, input)

starting_text.chars.permutation.each do |perm|
	sc = scramble(perm, input)
	if sc == "fbgdceah"
		puts perm.join
		break
	end
end

