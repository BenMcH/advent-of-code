def perform_explosion(snailfish, depth = 0)
  left, right = snailfish
  
  # If we've reached a pair at depth 4, it should explode
  if depth == 4 && left.is_a?(Integer) && right.is_a?(Integer)
    return [true, left, right, 0]  # [exploded?, left_val, right_val, replacement]
  end
  
  # Try to explode the left side if it's a pair
  if left.is_a?(Array)
    exploded, add_left, add_right, new_left = perform_explosion(left, depth + 1)
    
    if exploded
      # Replace the exploded pair with 0
      snailfish[0] = new_left
      
      # Add the right value to the leftmost value in the right side
      if add_right > 0
        if right.is_a?(Integer)
          snailfish[1] += add_right
        else
          # Find the leftmost value in the right side
          target = right
          path = []
          while target.is_a?(Array)
            path.push(0)
            target = target[0]
          end
          
          # Navigate to that value and add to it
          current = right
          path.each_with_index do |idx, i|
            if i == path.length - 1
              current[idx] += add_right
            else
              current = current[idx]
            end
          end
        end
      end
      
      return [true, add_left, 0, snailfish]
    end
  end
  
  # Try to explode the right side if it's a pair
  if right.is_a?(Array)
    exploded, add_left, add_right, new_right = perform_explosion(right, depth + 1)
    
    if exploded
      # Replace the exploded pair with 0
      snailfish[1] = new_right
      
      # Add the left value to the rightmost value in the left side
      if add_left > 0
        if left.is_a?(Integer)
          snailfish[0] += add_left
        else
          # Find the rightmost value in the left side
          target = left
          path = []
          while target.is_a?(Array)
            path.push(1)
            target = target[1]
          end
          
          # Navigate to that value and add to it
          current = left
          path.each_with_index do |idx, i|
            if i == path.length - 1
              current[idx] += add_left
            else
              current = current[idx]
            end
          end
        end
      end
      
      return [true, 0, add_right, snailfish]
    end
  end
  
  # No explosion happened
  return [false, 0, 0, snailfish]
end

def perform_split(snailfish)
  left, right = snailfish
  
  if left.is_a?(Integer) && left >= 10
    snailfish[0] = [left / 2, (left + 1) / 2]
    return [true, snailfish]
  elsif left.is_a?(Array)
    split, new_left = perform_split(left)
    if split
      snailfish[0] = new_left
      return [true, snailfish]
    end
  end
  
  if right.is_a?(Integer) && right >= 10
    snailfish[1] = [right / 2, (right + 1) / 2]
    return [true, snailfish]
  elsif right.is_a?(Array)
    split, new_right = perform_split(right)
    if split
      snailfish[1] = new_right
      return [true, snailfish]
    end
  end
  
  [false, snailfish]
end

def explode(snailfish)
  exploded, _, _, result = perform_explosion(Marshal.load(Marshal.dump(snailfish)))
  [exploded, result]
end

def add_snailfish(left, right)
  a = [left, right]
  loop do
    exploded, a = explode(a)
    next if exploded
    
    split, a = perform_split(a)
    break unless split
  end
  
  a
end

def expect_snailfish(left, right, output)
  actual = add_snailfish(left, right)

  raise "Expected #{output}, got #{actual}" if actual != output
end

expect_snailfish([1, 2], [[3, 4], 5], [[1, 2], [[3, 4], 5]])

def expect_explosion(snailfish, output)
  _, _, _, actual = perform_explosion(snailfish)

  raise "Expected #{output}, got #{actual}" if actual != output
end

expect_explosion([[[[[9,8],1],2],3],4], [[[[0,9],2],3],4])
expect_explosion([7,[6,[5,[4,[3,2]]]]], [7,[6,[5,[7,0]]]])
expect_explosion([[6,[5,[4,[3,2]]]],1], [[6,[5,[7,0]]],3])

def magnitude(snailfish)
  left, right = snailfish
  
  if left.is_a?(Array)
    left = magnitude(left)
  end
  
  if right.is_a?(Array)
    right = magnitude(right)
  end
  
  return 3 * left + 2 * right
end

raise unless magnitude([[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]) == 3488

lines = File.readlines("input.txt", chomp: true).map { |line| eval(line) }

ans = lines[1..].reduce(lines.first) do |acc, val|
  a = add_snailfish(acc, val)
end
p magnitude(ans)

p lines.permutation(2).map { |pair| magnitude(add_snailfish(pair[0], pair[1])) }.max
