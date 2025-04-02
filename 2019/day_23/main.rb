require_relative '../intcode.rb'

input = File.read("./input.txt")

computers = [0] * 50

computers = computers.map.with_index do |c, i|
  c = Intcode.new(input)
  c.inputs << i
  
  c
end

wrong_address = false

until wrong_address do 
  computers.each do |c|
    c.step
    
    if c.waiting_for_input
      c.inputs << -1
      c.step
    end
    
    if c.outputs.length == 3
      address, x, y = c.outputs
      c.outputs = []
      
      if address == 255
        puts y
        wrong_address = true
        break
      end
      
      comp = computers[address]
      comp.inputs << x
      comp.inputs << y
    end
  end
end

computers.each(&:reset)
