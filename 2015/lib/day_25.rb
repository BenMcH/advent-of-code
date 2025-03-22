row, col = File.read("resources/input-25").strip.scan(/\d+/).map(&:to_i)

def generate_code(target_row, target_col)
  current_code = 20151125
  
  diagonal = target_row + target_col - 1
  previous_items = diagonal * (diagonal - 1) / 2
  position_in_diagonal = diagonal - target_row + 1
  target_position = previous_items + position_in_diagonal
  
  (target_position - 1).times do
    current_code = (current_code * 252533) % 33554393
  end
  
  return current_code
end

p generate_code(row, col)
