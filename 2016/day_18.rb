input = File.read('./resources/input-18').strip.chars

def next_row(row)
	row.each_with_index.map do |val, i|
		center_trap = row[i] == '^'
		right_trap = (row[i + 1] || '.') == '^'
		left_trap = (i > 0 ? row[i - 1] : '.') == '^'
		
		if left_trap ^ right_trap
			'^'
		else
			'.'
		end
	end
end

rows = [input]

row = input

i = 1
count = row.count('.')

until i == 40
	row = next_row(row)
	row_count = row.count('.')
	count += row_count
	i += 1
end

p count

until i == 400000
	row = next_row(row)
	row_count = row.count('.')
	count += row_count
	i += 1
end

p count
