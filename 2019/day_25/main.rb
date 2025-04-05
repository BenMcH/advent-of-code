require_relative "../intcode"

computer = Intcode.new(File.read("./input.txt"))

computer.inputs = "south\nwest\ntake shell\neast\neast\ntake space heater\nwest\nnorth\nwest\nnorth\ntake jam\nnorth\ntake astronaut ice cream\nnorth\neast\nsouth\ntake space law space brochure\nnorth\nwest\nsouth\neast\nwest\nsouth\neast\nsouth\ntake asterisk\nsouth\ntake klein bottle\neast\ntake spool of cat6\ninv\nwest\nnorth\neast\nwest\nnorth\nwest\nsouth\neast\nwest\nsouth\nwest\n".chars.map(&:ord)

inputs = ""

items = [
  "spool of cat6",
  "space law space brochure",
  "asterisk",
  "jam",
  "shell",
  "astronaut ice cream",
  "space heater",
  "klein bottle"
]

computer.inputs += items.map{|i| "drop #{i}\n"}.join("").chars.map(&:ord)

combos = (1..items.length).each do |i|
  items.combination(i).each do |arr|
    takes = arr.map{|item| "take #{item}\n"}    
    takes << "south\n"
    takes += arr.map{|item| "drop #{item}\n"}
    computer.inputs += takes.join.chars.map(&:ord)
  end
end

until computer.halted
  computer.step
  computer.step until computer.waiting_for_input || computer.halted

  while computer.outputs.any?
    print(computer.outputs.shift(1)[0].chr)
  end

  input = ""
  input = gets() unless computer.halted

  if input.start_with? "quit"
    p inputs
    break
  end
  if input.start_with? "da"
    input = drop_all
  end

  inputs += input

  computer.inputs = input.chars.map{|ch| ch.ord}
end

