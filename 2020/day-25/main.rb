card, door = File.readlines("./data.txt", chomp: true).map(&:to_i)

card_loop = -1
door_loop = -1
next_loop = 1
value = 1
subj = 7

def transform(value, subj = 7)
  (value * subj) % 20201227
end

while card_loop == -1 || door_loop == -1

  value = transform(value)

  if value == card
    card_loop = next_loop
    p "card loop: #{next_loop}"
  end

  if value == door
    door_loop = next_loop
    p "door loop: #{next_loop}"
  end

  next_loop += 1
end

_card = card
card = 1
door_loop.times do
  card = transform(card, _card)
end

p card

_door = door
door = 1
card_loop.times do
  door = transform(door, _door)
end

p door
