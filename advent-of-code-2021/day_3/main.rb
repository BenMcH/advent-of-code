gamma = ''
epsilon = ''

rows = File.read('input.txt').split("\n").map do |line|
	line.split('')
end

columns = rows.transpose

columns.each do |column|
	zeros = column.count('0')
	ones = column.count('1')
	
	if zeros > ones
		gamma += '0'
		epsilon += '1'
	else
		gamma += '1'
		epsilon += '0'
	end
end

p gamma.to_i(2) * epsilon.to_i(2)

oxygen_code = 0
co2_code = 0

co2_rows = rows.dup
oxygen_rows = rows.dup

column_height = columns.first.length - 1

for i in 0..column_height
	oxygen_cols = oxygen_rows.transpose
	co2_cols = co2_rows.transpose

	if oxygen_rows.length > 1 && oxygen_cols[i].count('0') > oxygen_cols[i].count('1')
		oxygen_rows = oxygen_rows.filter do |row|
			row[i] == '0'
		end
	else
		oxygen_rows = oxygen_rows.filter do |row|
			row[i] == '1'
		end
	end

	if co2_rows.length > 1 && co2_cols[i].count('0') > co2_cols[i].count('1')
		co2_rows = co2_rows.filter do |row|
			row[i] == '1'
		end
	else
		co2_rows = co2_rows.filter do |row|
			row[i] == '0'
		end
	end

	oxygen_code = oxygen_rows[0].join.to_i(2) if oxygen_rows.length == 1
	co2_code = co2_rows[0].join.to_i(2) if co2_rows.length == 1
end

p oxygen_code * co2_code
