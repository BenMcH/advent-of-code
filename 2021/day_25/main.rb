map = Hash.new()

lines = File.readlines("./input.txt", chomp: true)
lines.each_with_index do |row, y|
  row.chars.each_with_index do |ch, x|
    next if ch == '.'
    map[[x,y]] = ch
  end
end

@max_y = lines.length - 1
@max_x = lines[0].length - 1

def step_right(map)
  n_map = Hash.new
  stepped = false
  map.each do |pt, ch|
    if ch == ">"
      x, y = pt
      
      x += 1
      x = 0 if x > @max_x
      if map[[x, y]].nil?
        n_map[[x, y]] = '>'  
        stepped = true
      else
        n_map[pt] = '>'
      end
    else
      n_map[pt] = ch
    end
  end
  
  return n_map, stepped
end

def step_down(map)
  n_map = Hash.new
  stepped = false
  map.each do |pt, ch|
    if ch == "v"
      x, y = pt
      
      y += 1
      y = 0 if y > @max_y
      if map[[x, y]].nil?
        n_map[[x,y]] = 'v'  
        stepped = true
      else
        n_map[pt] = 'v'
      end
    else
      n_map[pt] = ch
    end
  end
  
  return n_map, stepped
end

def p_board(map)
  puts "-"* 50
  (0..@max_y).each do |y|
    (0..@max_x).each do |x|
      print(map[[x, y]] || '.')
    end
    puts ""
  end
end

i = 0
loop do
  map, stepped_right = step_right(map)
  map, stepped_down = step_down(map)
  i += 1
  
  
  break unless stepped_right || stepped_down
end

p i
