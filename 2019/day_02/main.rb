
require_relative "../intcode.rb"
input = File.read("./input.txt").strip
#input = "1,9,10,3,2,3,11,0,99,30,40,50"

computer = Intcode.new(input)

computer.program[1] = 12
computer.program[2] = 2

computer.step until computer.halted

p computer.program[0]

(0...computer.program.length).each do |noun|
  (0...computer.program.length).each do |verb|
    computer.reset
    computer.program[1] = noun
    computer.program[2] = verb
    computer.step until computer.halted

    if computer.program[0] == 19690720
      res = 100 * noun + verb
      puts  res
      return
    end
  end
end
