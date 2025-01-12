
screen = []

(0..5).each do
  screen << [false] * 50
end

input = File.readlines("./input.txt").map{ |line| line.split(/\s+/) }

def draw(screen)
  str = ""
  screen.each do |row|
    row.each do |val|
      if val
        str << "#"
      else
        str << " "
      end
    end
    str << "\n"
  end
  puts str
  puts "-----"
end

input.each do |line|
  case line[0]
  when "rect"
    x, y = line[1].split("x").map { |v| v.to_i - 1 }
    
    (0..y).each do |y|
      (0..x).each do |x|
        screen[y][x] = true
      end
    end
  when "rotate"
    dir = line[1]
    index = line[2][2..].to_i
    amount = line[-1].to_i

    if dir == "row"
      row = screen[index]
      screen[index] = row.last(amount) + row.first(row.length - amount)
    else
      row = screen.map { |r| r[index] }
      row = row.last(amount) + row.first(row.length - amount)
      
      row.each_with_index do |val, i|
        screen[i][index] = val
      end
    end
  end

  draw(screen)
end

p screen.sum { |row| row.count(true) }
