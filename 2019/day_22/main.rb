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

def parse_shuffle(instructions, deck_size)
  a, b = 1, 0

  instructions.each do |line|
    if line == "deal into new stack"
      a = -a % deck_size
      b = (-b - 1) % deck_size
    elsif line.start_with?("cut")
      n = line.split.last.to_i
      b = (b - n) % deck_size
    elsif line.start_with?("deal with increment")
      n = line.split.last.to_i
      a = (a * n) % deck_size
      b = (b * n) % deck_size
    end
  end

  [a, b]
end

def mod_exp(base, exp, mod)
  result = 1
  while exp > 0
    result = (result * base) % mod if exp.odd?
    base = (base * base) % mod
    exp /= 2
  end
  result
end

def repeated_shuffle(a, b, repeats, deck_size)
  a_n = mod_exp(a, repeats, deck_size)
  b_n = (b * (a_n - 1) * mod_exp(a - 1, deck_size - 2, deck_size)) % deck_size
  [a_n, b_n]
end

def find_original_card(a, b, repeats, deck_size, position)
  a_n, b_n = repeated_shuffle(a, b, repeats, deck_size)
  mod_inv_a = mod_exp(a_n, deck_size - 2, deck_size) # Modular inverse of a_n
  ((position - b_n) * mod_inv_a) % deck_size
end

deck_size = 119315717514047
shuffles = 101741582076661
position = 2020

a, b = parse_shuffle(instructions, deck_size)
card = find_original_card(a, b, shuffles, deck_size, position)
puts card
