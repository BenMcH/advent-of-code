require_relative "../intcode.rb"

input = File.read("./input.txt")
computer = Intcode.new(input)

computer.step until computer.halted

screen = Hash.new(0)

computer.outputs.each_slice(3) do |a, b, c|
  screen[[b, a]] = c
end

def count_bricks(screen)
  count = 0

  screen.each do |k, v|
    if v == 2
      count += 1
    end
  end

  count
end

def ball_x(screen)
  screen.each do |pos, value|
    y, x = pos
    return x if value == 4  # 4 is the ball tile ID
  end
  -1
end

def paddle_x(screen)
  screen.each do |pos, value|
    y, x = pos
    return x if value == 3  # 3 is the paddle tile ID
  end
  -1
end

p count_bricks(screen)

computer.reset

computer.memory[0] = 2

screen = Hash.new(0)
score = 0

process_outputs = Proc.new do
  computer.outputs.each_slice(3) do |a, b, c|
    if a == -1 && b == 0
      score = c
      next
    end
    if c == 0
      screen.delete([b, a])
    else
      screen[[b, a]] = c
    end
  end

  computer.outputs = []
end

until computer.halted
  computer.step

  if computer.waiting_for_input
    process_outputs.call()

    computer.inputs << (ball_x(screen) <=> paddle_x(screen))
  end
end

process_outputs.call()

p score
