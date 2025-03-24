require_relative '../intcode.rb'
computer = Intcode.new(File.read('./input.txt'))

$beam_cache = {}

def in_beam?(computer, x, y)
  return false if x < 0 || y < 0  # Negative coordinates are out of bounds
  
  cache_key = "#{x},#{y}"
  return $beam_cache[cache_key] if $beam_cache.has_key?(cache_key)
  
  computer.reset
  computer.inputs = [x, y]
  computer.step until computer.halted
  result = computer.outputs[0] == 1
  $beam_cache[cache_key] = result
  return result
end

count = 0

(0..49).each do |x|
  (0..49).each do |y|
    count += 1 if in_beam?(computer, x, y) 
  end
end

p count

def find_square_start(computer, size)
  y = size * 10
  
  loop do
    x_start = 0
    x_start += 1 until in_beam?(computer, x_start, y)
    
    x_end = x_start
    x_end += 1 while in_beam?(computer, x_end, y)
    x_end -= 1
    
    
    (x_start..x_end - (size - 1)).each do |x|
      if in_beam?(computer, x, y) && 
         in_beam?(computer, x + (size - 1), y) && 
         in_beam?(computer, x, y + (size - 1)) && 
         in_beam?(computer, x + (size - 1), y + (size - 1))
        return [x, y]
      end
    end
    
    y += 1
    puts "Checking y=#{y}..." if y % 100 == 0  # Progress indicator
  end
end

# Find the first point where a 100x100 square fits
start_point = find_square_start(computer, 100)
puts "Part 2: #{start_point[0] * 10000 + start_point[1]}"
