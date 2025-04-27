require 'set'


# Part 1: The first value that would cause the program to halt
def part1
  seen_values = Set.new
  r4 = 0
  
  r3 = r4 | 65536  # bori 4 65536 3
  r4 = 4332021     # seti 4332021 4 4
  
  loop do
    r2 = r3 & 255    # bani 3 255 2
    r4 = (r4 + r2) & 16777215  # addr 4 2 4, bani 4 16777215 4
    r4 = (r4 * 65899) & 16777215  # muli 4 65899 4, bani 4 16777215 4
    
    if 256 > r3  # gtir 256 3 2
      # This is where the program checks if r4 == r0
      # For part 1, we want the first value of r4
      return r4
    end
    
    r3 = r3 / 256  # Several instructions that effectively divide r3 by 256
  end
end

# Part 2: The last value before the cycle repeats
def part2
  seen_values = Set.new
  last_value = nil
  r4 = 0
  
  loop do
    r3 = r4 | 65536  # bori 4 65536 3
    r4 = 4332021     # seti 4332021 4 4
    
    loop do
      r2 = r3 & 255    # bani 3 255 2
      r4 = (r4 + r2) & 16777215  # addr 4 2 4, bani 4 16777215 4
      r4 = (r4 * 65899) & 16777215  # muli 4 65899 4, bani 4 16777215 4
      
      if 256 > r3
        # Instead of comparing to r0, we detect cycles
        if seen_values.include?(r4)
          return last_value
        end
        
        seen_values.add(r4)
        last_value = r4
        break
      end
      
      r3 = r3 / 256
    end
  end
end

puts "Part 1: The value for register 0 is #{part1}"
puts "Part 2: The value for register 0 is #{part2}"
