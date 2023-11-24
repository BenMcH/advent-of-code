def get_pos(max, instructions, upper_char)
    ids = (0..max).to_a
    instructions.chars.each {|upper_lower| ids = ids.each_slice(ids.length / 2).to_a[upper_lower == upper_char ? 0 : 1]}
    ids[0]
end

boarding_passes = File.read('./data.txt').split.map{|pass|[pass[0..6], pass[7..-1]]}
all_seat_ids = boarding_passes.map{|pass| get_pos(127, pass[0], 'F') * 8 + get_pos(7, pass[1], 'L')}
missing_seat = all_seat_ids.sort.find{|pass| !all_seat_ids.include?(pass+1)} + 1

puts all_seat_ids.max
puts missing_seat
