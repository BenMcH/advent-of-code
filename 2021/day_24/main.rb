input = File.readlines("./input.txt", chomp: true)

stacks = []

while input.length > 0
  i = input.rindex("inp w")
  
  prog = input[i..]
  input = input[0...i]
  
  stacks << prog.map { |row| row.split(" ") }
end

stacks.reverse!

uniq_params = stacks.map do |stack|
  z_idx = stack.index { |row| row[0] == "div" && row[1] == "z" }
  
  z = stack[z_idx][-1].to_i
  x = stack[z_idx + 1][-1].to_i

  y = stack.reverse.find { |r| r[0] == "add" && r[1] == "y" }[-1].to_i

  [x, y, z]
end

stack = []
constraints = []

uniq_params.each_with_index do |(x_add, y_add, z_div), i|
  if z_div == 1
    # Push: store index and y_add for later use
    stack << [i, y_add]
  else
    # Pop: get last pushed digit
    j, prev_y = stack.pop
    delta = prev_y + x_add
    constraints << [j, i, delta]
  end
end

digits = Array.new(14, 0)

constraints.each do |i1, i2, delta|
  if delta > 0
    digits[i1] = 9 - delta
    digits[i2] = 9
  else
    digits[i1] = 9
    digits[i2] = 9 + delta
  end
end

digits.map! { |d| [[d, 1].max, 9].min }

puts "Largest valid model number: #{digits.join}"

digits = Array.new(14, 0)

constraints.each do |i1, i2, delta|
  if delta > 0
    digits[i1] = 1
    digits[i2] = 1 + delta
  else
    digits[i1] = 1 - delta
    digits[i2] = 1
  end
end

digits.map! { |d| [[d, 1].max, 9].min }

puts "Smallest valid model number: #{digits.join}"
