require_relative '../intcode.rb'

input = File.read("./input.txt")

computers = [0] * 50

computers = computers.map.with_index do |c, i|
  c = Intcode.new(input)
  c.inputs << i
  
  c
end

part_1 = false
part_2 = false
nat = nil

idle_count = 0

loop do 
  idle = false

  computers.each do |c|

    while c.outputs.length >= 3
      address, x, y = c.outputs.shift(3)

      if address == 255
        new_nat = [x, y]
        puts "Part 1: #{y}" unless part_1
        part_1 = true

        if nat == new_nat
          puts "Part 2: #{y}" unless part_2
          part_2 = true
          break
        end

        nat = new_nat
        next
      end

      comp = computers[address]
      comp.inputs << x
      comp.inputs << y
    end

    c.inputs << -1 if c.inputs.empty?
  end

  computers.each do |c|
    c.step
    c.step until c.waiting_for_input
  end

  idle = computers.all?{|c| c.outputs.empty?}


  idle_count = idle ? idle_count + 1 : 0
  if idle_count > 1
    computers[0].inputs << nat[0]
    computers[0].inputs << nat[1]
  end

  break if part_2
end

