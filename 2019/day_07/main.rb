require_relative "../intcode.rb"

input = File.read("./input.txt")

def circuit(input, phases)
  computers = []
  _input = 0

  5.times do |i|
    computer = Intcode.new(input)
    computer.inputs << phases[i]
    computer.inputs << _input

    computer.step until computer.halted

    _input = computer.outputs[0]
  end

  _input
end

max = 0

# p circuit("3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0", [4, 3, 2, 1, 0])

(0..4).to_a.permutation.each do |phases|
  res = circuit(input, phases)

  if res > max
    max = res
  end
end

p max
