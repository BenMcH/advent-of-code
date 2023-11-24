input = File.read('input.txt').split("\n").map(&:to_i)

greater = 0

input.each.with_index do |n, i|
	next if i == 0

	if n > input[i - 1]
		greater += 1
	end
end

p greater

new_ary = []

input.each.with_index do |n, i|
	next if i < 2
	number = n
	number += input[i - 1]
	number += input[i - 2]

	new_ary << number
end

greater = 0
new_ary.each.with_index do |n, i|
	next if i == 0
	if n > new_ary[i - 1]
		greater += 1
	end
end

p greater
