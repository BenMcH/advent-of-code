examples, prog = File.read("./inputs/day16.txt").split("\n\n\n")

examples = examples.split("\n\n").map do |ex|
  ex.scan(/\d+/).map(&:to_i)
end


def test_example(example)
  before_a, before_b, before_c, before_d, op, in_a, in_b, out_register, after_a, after_b, after_c, after_d = example

  before = [before_a, before_b, before_c, before_d]
  after = [after_a, after_b, after_c, after_d]
  out = after[out_register]
  
  before_register_a = before[in_a]
  before_register_b = before[in_b]
 
  options = []
  
  if out == before_register_a + before_register_b
    options << :addr
  end
  
  if out == before_register_a + in_b
    options << :addi
  end

  if out == before_register_a * before_register_b
    options << :mulr
  end

  if out == before_register_a * in_b
    options << :muli
  end

  if out == before_register_a & before_register_b
    options << :banr
  end

  if out == before_register_a & in_b
    options << :bani
  end

  if out == before_register_a | before_register_b
    options << :borr
  end

  if out == before_register_a | in_b
    options << :bori
  end

  if out == before_register_a
    options << :setr
  end

  if out == in_a
    options << :seti
  end

  if out == (in_a > before_register_b ? 1 : 0)
    options << :gtir
  end

  if out == (before_register_a > in_b ? 1 : 0)
    options << :gtri
  end

  if out == (before_register_a > before_register_b ? 1 : 0)
    options << :gtrr
  end

  if out == (in_a == before_register_b ? 1 : 0)
    options << :eqir
  end

  if out == (before_register_a == in_b ? 1 : 0)
    options << :eqri
  end

  if out == (before_register_a == before_register_b ? 1 : 0)
    options << :eqrr
  end

  options
end

mappings = examples.map do |ex|
  opcode = ex[4]
  
  [opcode, test_example(ex)]
end

p mappings.select { |_, v| v.length >= 3 }.length

h = {}

mappings.each do |opcode, ops|
  h[opcode] ||= ops
  
  h[opcode] &= ops
end

real_mappings = {}

while h.any?
  opcode, ops = h.find { |_, v| v.length == 1 }

  real_mappings[opcode] = ops[0]

  h.delete(opcode)

  h.each do |k, v|
    h[k] -= ops
  end
end


registers = [0, 0, 0, 0]

prog.strip.split("\n").each do |line|
  opcode, a, b, c = line.scan(/\d+/).map(&:to_i)

  op = real_mappings[opcode]

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
end

p registers[0]
