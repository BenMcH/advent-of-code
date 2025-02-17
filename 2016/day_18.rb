input = File.read('./resources/input-18').strip.chars.map { |c| c == '^' }

def next_row(row)
	row.each_with_index.map do |val, i|
		right_trap = (row[i + 1] || false)
		left_trap = (i > 0 ? row[i - 1] : false)

		left_trap ^ right_trap
	end
end

row = input

i = 1
count = row.count(false)

until i == 400_000
	row = next_row(row)
	row_count = row.count(false)
	count += row_count
	i += 1
	p count if i == 40
end

p count
