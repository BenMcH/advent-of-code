
ip_reg = 6
registers = [0, 0, 0, 0, 0, 0, 0]

instructions = File.read("./inputs/day19.txt").strip.split("\n")

ip_reg = instructions.shift.scan(/\d+/).first.to_i

instructions.map! do |line|
  a, b, c = line.scan(/\d+/).map(&:to_i)

  op = line.split(" ")[0].to_sym
  
  [op, a, b, c]
end

until registers[ip_reg] >= instructions.size
  line = instructions[registers[ip_reg]]
  
  op, a, b, c = line
  

  case op
  when :addr
    registers[c] = registers[a] + registers[b]
  when :addi
    registers[c] = registers[a] + b
  when :mulr
    registers[c] = registers[a] * registers[b]
  when :muli
    registers[c] = registers[a] * b
  when :banr
    registers[c] = registers[a] & registers[b]
  when :bani
    registers[c] = registers[a] & b
  when :borr
    registers[c] = registers[a] | registers[b]
  when :bori
    registers[c] = registers[a] | b
  when :setr
    registers[c] = registers[a]
  when :seti
    registers[c] = a
  when :gtir
    registers[c] = (a > registers[b] ? 1 : 0)
  when :gtri
    registers[c] = (registers[a] > b ? 1 : 0)
  when :gtrr
    registers[c] = (registers[a] > registers[b] ? 1 : 0)
  when :eqir
    registers[c] = (a == registers[b] ? 1 : 0)
  when :eqri
    registers[c] = (registers[a] == b ? 1 : 0)
  when :eqrr
    registers[c] = (registers[a] == registers[b] ? 1 : 0)
  else
    raise "Unknown opcode: #{op}"
  end
  
  registers[ip_reg] += 1
end

p registers[0]

registers = [1, 0, 0, 0, 0, 0, 0]

i = 0

until registers[ip_reg] >= instructions.size
  line = instructions[registers[ip_reg]]
  
  old_ip = registers[ip_reg]
  
  op, a, b, c = line
  

  case op
  when :addr
    registers[c] = registers[a] + registers[b]
  when :addi
    registers[c] = registers[a] + b
  when :mulr
    registers[c] = registers[a] * registers[b]
  when :muli
    registers[c] = registers[a] * b
  when :banr
    registers[c] = registers[a] & registers[b]
  when :bani
    registers[c] = registers[a] & b
  when :borr
    registers[c] = registers[a] | registers[b]
  when :bori
    registers[c] = registers[a] | b
  when :setr
    registers[c] = registers[a]
  when :seti
    registers[c] = a
  when :gtir
    registers[c] = (a > registers[b] ? 1 : 0)
  when :gtri
    registers[c] = (registers[a] > b ? 1 : 0)
  when :gtrr
    registers[c] = (registers[a] > registers[b] ? 1 : 0)
  when :eqir
    registers[c] = (a == registers[b] ? 1 : 0)
  when :eqri
    registers[c] = (registers[a] == b ? 1 : 0)
  when :eqrr
    registers[c] = (registers[a] == registers[b] ? 1 : 0)
  else
    raise "Unknown opcode: #{op}"
  end
  
  registers[ip_reg] += 1
  i += 1
  
  # break if registers[ip_reg] < old_ip
  # 
  p registers
end

sum = (1..registers.max).sum {
  |i| registers[4] % i == 0 ? i : 0
}

p sum
