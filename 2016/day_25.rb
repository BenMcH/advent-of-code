require_relative "./day_12.rb"

computer = Computer.new(File.read("./resources/input-25"))

i = 1
loop do
  res = computer.run(0, i)

  break if res == 0

  i += 1
end

p i
