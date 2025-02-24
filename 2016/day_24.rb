RubyVM::YJIT.enable
input = File.read("./resources/input-24")

numbers_h = {}
grid = Hash.new("#")

Point = Struct.new(:x, :y) do
  def neighbors
    [
      Point.new(x + 1, y),
      Point.new(x - 1, y),
      Point.new(x, y + 1),
      Point.new(x, y - 1),
    ]
  end
end

input.each_line.with_index do |line, y|
  line.each_char.with_index do |char, x|
    next if char == "#"
    point = Point.new(x, y)

    if char.match(/\d/)
      numbers_h[char.to_i] = point
    end

    grid[point] = "."
  end
end

def bfs(start, goal, grid)
  visited = {}

  queue = [[start, 0]]

  while queue.any?
    point, dist = queue.shift

    return dist if point == goal

    point.neighbors.each do |neighbor|
      next if grid[neighbor] == "#"
      next if visited[neighbor]

      visited[neighbor] = true
      queue << [neighbor, dist + 1]
    end
  end
end

nums = numbers_h.keys
cache = {}

dists = nums.product(nums).map do |pair|
  a, b = pair

  if a == b
    [pair, Float::INFINITY]
  else
    [pair, bfs(numbers_h[a], numbers_h[b], grid)]
  end
end.to_h

min_dist = nums.each_cons(2).sum { |a, b| dists[[a, b]] }

queue = [[[0], 0]]

until queue.empty?
  path, dist = queue.shift

  if nums.all? { |num| path.include?(num) }
    min_dist = [min_dist, dist].min
    next
  end

  nums.each do |num|
    next if num == path[-1] || (num == path[-2] && path[-1] == path[-3])
    _dist = dist + dists[[path[-1], num]]

    if _dist < min_dist
      _path = path + [num]
      queue << [_path, _dist]
    end
  end
end

p min_dist

_nums = [0] + nums + [0]

min_dist = _nums.each_cons(2).sum { |a, b| dists[[a, b]] }

queue = [[[0], 0]]

until queue.empty?
  path, dist = queue.shift
  next if dist > min_dist

  if path[-1] == 0 && nums.all? { |num| path.include?(num) }
    min_dist = [min_dist, dist].min
    next
  end

  nums.each do |num|
    _path = path + [num]
    _dist = dist + dists[[path[-1], num]]

    if _dist < min_dist
      queue << [_path, _dist]
    end
  end
end

p min_dist
