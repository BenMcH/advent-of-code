require_relative "../intcode.rb"

input = File.read("./input.txt")

computer = Intcode.new(input)

computer.inputs << 1

computer.step until computer.halted

p computer.outputs.filter(&:positive?)[0]

computer.reset

computer.inputs << 5

computer.step until computer.halted

p computer.outputs[0]
