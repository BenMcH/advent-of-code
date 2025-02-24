require_relative "./day_12.rb"

c = Computer.new(File.read("./resources/input-23"))

puts "Part 1: #{c.run(0, 7)}"

c = Computer.new(File.read("./resources/input-23"))
puts "Part 2: #{c.run(0, 12)}"
