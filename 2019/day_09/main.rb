require_relative "../intcode.rb"

input = File.read("./input.txt")

quine = "109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99"
quine_computer = Intcode.new(quine)

quine_computer.step until quine_computer.halted
raise "Quine failed" unless quine_computer.outputs.join(",") == quine

sdn = Intcode.new("104,1125899906842624,99")
sdn.step until sdn.halted
p sdn.outputs

computer = Intcode.new(input)
computer.inputs << 1

computer.step until computer.halted

raise computer.outputs if computer.outputs.length > 1

puts "Part 1: #{computer.outputs[0]}"

computer.reset

computer.inputs << 2
computer.step until computer.halted

raise computer.outputs if computer.outputs.length > 1

puts "Part 2: #{computer.outputs[0]}"
