instructions = File.readlines("./input.txt", chomp: true)

cards = (0..10006).to_a

instructions.each do |inst|
  if inst == "deal into new stack"
    cards.reverse!
  elsif inst.start_with? "cut "
    inst = inst[4..].to_i
    
    if inst < 0
      inst = cards.length + inst
    end
    
    a, b = cards[0...inst], cards[inst..-1]
    
    cards = b + a
elsif inst.start_with? "deal with increment"
  inc = inst[20..].to_i
  new_stack = Array.new(cards.length)
  
  cards.each_with_index do |card, idx|
    new_position = (idx * inc) % cards.length
    new_stack[new_position] = card
  end
  
  cards = new_stack
  else
    raise inst
  end
end

p cards.index(2019)
