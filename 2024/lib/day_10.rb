class Day10
  def self.parse(input)
    input.split("\n").map { |line| line.chars.map(&:to_i) }
  end

  def self.score(grid, row, col, prev = -1)
    return 0, [] if row < 0 || col < 0 || row >= grid.length || col >= grid[0].length

    num = grid[row][col]

    return [0, []] if num - 1 != prev
    return [1, [[row, col]]] if num == 9

    total = 0
    trailheads = []

    up_total, up_trails = score(grid, row - 1, col, num)
    total += up_total
    trailheads += up_trails

    down_total, down_trails = score(grid, row + 1, col, num)
    total += down_total
    trailheads += down_trails

    left_total, left_trails = score(grid, row, col - 1, num)
    total += left_total
    trailheads += left_trails

    right_total, right_trails = score(grid, row, col + 1, num)
    total += right_total
    trailheads += right_trails

    return [total, trailheads]
  end

  def self.part_1(input)
    input = parse(input)
    s = 0
    trailheads = []

    input.each_with_index do |row, i|
      row.each_with_index do |num, j|
        if num == 0
          _score, _trailheads = score(input, i, j)
          s += _trailheads.uniq.length
          trailheads += _trailheads
        end
      end
    end

    s
  end

  def self.part_2(input)
    input = parse(input)
    s = 0
    trailheads = []

    input.each_with_index do |row, i|
      row.each_with_index do |num, j|
        if num == 0
          _score, _trailheads = score(input, i, j)
          s += _score
        end
      end
    end

    s
  end
end
