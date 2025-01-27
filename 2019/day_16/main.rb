require 'set'
input = File.read('input.txt').strip.chars.map(&:to_i)

# Part 1
def part1(input)
  len = input.length
  
  100.times do
    # Calculate cumulative sums once per iteration
    sums = Array.new(len + 1, 0)
    (len - 1).downto(0) do |i|
      sums[i] = sums[i + 1] + input[i]
    end
    
    # For each position
    input = len.times.map do |pos|
      period = (pos + 1) * 4
      sum = 0
      
      # Add segments where multiplier is 1
      i = pos
      while i < len
        next_i = [i + pos + 1, len].min
        sum += sums[i] - sums[next_i]
        i += period
      end
      
      # Subtract segments where multiplier is -1
      i = pos + (period / 2)
      while i < len
        next_i = [i + pos + 1, len].min
        sum -= sums[i] - sums[next_i]
        i += period
      end
      
      sum.abs % 10
    end
  end

  input[0..7].join
end

# Part 2
def part2(input)
  # Get offset from first 7 digits
  offset = input[0..6].join.to_i
  
  # Create the full input (original repeated 10000 times)
  full_input = (input * 10000)[offset..]
  len = full_input.length
  
  # If we're in the second half, we can use a much simpler algorithm
  # because the pattern becomes triangular (all zeros before position)
  raise "Offset must be in second half for optimization" if offset < input.length * 10000 / 2
  
  100.times do
    # For second half positions, each digit only depends on itself and later digits
    # The pattern is all 1s after the position
    sum = 0
    (len - 1).downto(0) do |i|
      sum = (sum + full_input[i]) % 10
      full_input[i] = sum
    end
  end
  
  full_input[0..7].join
end

puts "Part 1: #{part1(input)}"
puts "Part 2: #{part2(input)}"
