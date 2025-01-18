require_relative "../intcode.rb"

input = File.read("./input.txt")

def circuit(input, phases)
  computers = []
  _input = 0

  5.times do |i|
    computer = Intcode.new(input)

    if i > 0
      computer.inputs = computers[i - 1].outputs
    end

    computer.inputs << phases[i]
    computers << computer
  end

  computers[0].inputs << 0

  if 5 in phases
    computers.last.outputs = computers.first.inputs
  end

  loop do
    computers.each do |computer|
      computer.step
    end

    if computers.last.halted
      return computers.last.outputs.last
    end
  end
end

max = 0

(0..4).to_a.permutation.each do |phases|
  res = circuit(input, phases)

  if res > max
    max = res
  end
end

p max

max = 0

(5..9).to_a.permutation.each do |phases|
  res = circuit(input, phases)

  if res > max
    max = res
  end
end

p max
