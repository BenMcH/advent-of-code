map = {}

File.foreach("./inputs/day18.txt").with_index do |line, y|
  line.chomp.chars.each_with_index do |char, x|
    map[[y, x]] = char
  end
end

def neighbors(loc)
  y, x = loc
  [
    [y - 1, x],
    [y + 1, x],
    [y, x - 1],
    [y, x + 1],
    [y - 1, x - 1],
    [y - 1, x + 1],
    [y + 1, x - 1],
    [y + 1, x + 1]
  ]
end

def next_cell(map, loc)
  n = neighbors(loc).map { |n| map[n] }.tally
  
  case map[loc]
  when "."
    if (n["|"] || 0) >= 3
      "|"
    else
      "."
    end
  when "#"
    if (n["#"] || 0) >= 1 && (n["|"] || 0) >= 1
      "#"
    else
      "."
    end 
  when "|"
    if (n["#"] || 0) >= 3
      "#"
    else
      "|"
    end
  end
end

def next_iteration(map)
  new_map = {}

  map.each do |loc, cell|
    new_map[loc] = next_cell(map, loc)
  end
  
  new_map
end

maps = []
scores = []

10.times do
  map = next_iteration(map)
  values = map.values.tally

  scores << values["#"] * values["|"]
end

values = map.values.tally

p values["#"] * values["|"]

iterations = 1000000000 - 10

x = 10
until x == 1000000000 do
  x += 1
  map = next_iteration(map)

  values = map.values.tally

  score = values["#"] * values["|"]

  scores << score
  
  if x == 416
    cycle_size = 28
    iterations_left = 1000000000 - x
    
    x += (iterations_left / cycle_size) * cycle_size
  end
end

values = map.values.tally

p values["#"] * values["|"]
