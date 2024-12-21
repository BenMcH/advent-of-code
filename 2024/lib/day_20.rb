class Day20
  Point = Struct.new(:y, :x)

  def self.parse(input)
    input = input.strip.split("\n").map(&:chars)
    scores = Hash.new(Float::INFINITY)

    grid = {}
    start = Point.new(0, 0)
    end_p = Point.new(0, 0)
    input.each_with_index do |row, y|
      row.each_with_index do |col, x|
        grid[Point.new(y, x)] = col
        if col == "S"
          scores[Point.new(y, x)] = 0
          start = Point.new(y, x)
        end
        if col == "E"
          grid[Point.new(y, x)] = "."
          end_p = Point.new(y, x)
        end
      end
    end

    return grid, scores, start, end_p
  end

  def self.neighbors(point)
    [
      Point.new(point.y - 1, point.x),
      Point.new(point.y + 1, point.x),
      Point.new(point.y, point.x - 1),
      Point.new(point.y, point.x + 1),
    ]
  end

  def self.manhattan_dist(point, point_2)
    return (point.y - point_2.y).abs + (point.x - point_2.x).abs
  end

  def self.walk(grid, scores, point)
    queue = [point]

    while queue.length > 0
      point = queue.shift

      neighbors(point).each do |p|
        if grid[p] == "." && scores[p] > scores[point] + 1
          scores[p] = scores[point] + 1
          queue << p
        end
      end
    end
  end

  def self.count_cheats(scores, end_p, target, skips = 2)
    count = 0
    scores.each do |k, v|
      scores.each do |k2, score|
        next if score <= v
        dist = manhattan_dist(k, k2)
        next if dist > skips

        if score != Float::INFINITY and score > v + target + (dist - 1)
          count += 1
        end
      end
    end

    count
  end

  def self.part_1(input, target = 100)
    grid, scores, start, end_p = parse(input)

    walk(grid, scores, start)

    count_cheats(scores, end_p, target)
  end

  def self.part_2(input, target = 100)
    grid, scores, start, end_p = parse(input)

    walk(grid, scores, start)

    count_cheats(scores, end_p, target, 20)
  end
end
