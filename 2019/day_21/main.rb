require_relative '../intcode.rb'
input = File.read("./input.txt")

@computer = Intcode.new(input)

%{NOT B T
NOT C J
OR T J
AND D J
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

@computer.reset

%{NOT B T
NOT C J
OR T J
AND D J
AND H J
NOT A T
OR T J
RUN
}.chars.map(&:ord).each do |i|
  @computer.inputs << i
end


@computer.step until @computer.halted || @computer.waiting_for_input
print_output
