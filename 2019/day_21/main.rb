require_relative '../intcode.rb'
input = File.read("./input.txt")

@computer = Intcode.new(input)

%{NOT B T
NOT C J
OR J T
NOT D J
NOT J J
AND T J
NOT A T
OR T J
WALK
}.chars.map(&:ord).each do |i|
  @computer.inputs << i
end

@computer.step until @computer.halted || @computer.waiting_for_input


def print_output
  str = ""
  @computer.outputs.each {|c| str << c.chr}
  puts str
rescue RangeError
  p @computer.outputs[-1]
end

print_output
