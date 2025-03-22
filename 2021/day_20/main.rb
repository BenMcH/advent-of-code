require 'set'

file = File.readlines('input.txt', chomp: true)

alg, _, *lines = file
lines = lines.map(&:chars)

map = Hash.new(false)
lines.each_with_index do |row, i|
  row.each_with_index do |cell, j|
    map[[i, j]] = (cell == '#')
  end
end

def neighbors_to_key(map, y, x)
  ys = (y-1..y+1).to_a
  xs = (x-1..x+1).to_a
  ys.product(xs).map { |yy, xx| map[[yy, xx]] ? '1' : '0' }.join.to_i(2)
end

def enhance(map, alg, step)
  cur_val = map.default
  new_val = (alg[0] == '#' && !cur_val) ? true : (alg[511] == '.' && cur_val) ? false : !cur_val
  new_map = Hash.new(new_val)

  min_y, max_y = map.keys.map(&:first).minmax
  min_x, max_x = map.keys.map(&:last).minmax

  ((min_y - 1)..(max_y + 1)).each do |y|
    ((min_x - 1)..(max_x + 1)).each do |x|
      k = neighbors_to_key(map, y, x)
      new_map[[y, x]] = alg[k] == '#'
    end
  end

  new_map
end

2.times do |step|
  map = enhance(map, alg, step)
end

puts map.values.count(true)

48.times do |step|
  map = enhance(map, alg, step)
end

puts map.values.count(true)
