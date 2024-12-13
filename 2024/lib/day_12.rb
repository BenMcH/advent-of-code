class Day12
  def self.parse(input)
    input.split("\n").map { |line| line.chars }
  end

  def self.flood_fill(input, i, j, visited, group = {})
    group[[i, j]] = true
    num = input[i][j]
    visited[[i, j]] = true

    neighbors = [
      [i - 1, j],
      [i + 1, j],
      [i, j - 1],
      [i, j + 1],
    ].filter do |_i, _j|
      _i >= 0 && _i < input.length && _j >= 0 && _j < input[0].length && input[_i][_j] == num && visited[[_i, _j]].nil?
    end

    neighbors.each do |n|
      visited[n] = true
      flood_fill(input, n[0], n[1], visited, group)
    end

    return group
  end

  def self.price(group)
    fences = group.map do |k, v|
      [
        [k[0] + 1, k[1]],
        [k[0] - 1, k[1]],
        [k[0], k[1] + 1],
        [k[0], k[1] - 1],
      ].filter do |n|
        group[n].nil?
      end
    end

    fences.map { |f| f.length }.sum * group.keys.length
  end

  def self.part_1(input)
    input = parse(input)

    groups = []
    visited = {}

    input.each_with_index do |row, i|
      row.each_with_index do |col, j|
        next unless visited[[i, j]].nil?

        group = flood_fill(input, i, j, visited)

        groups << group
      end
    end

    groups.map { |g| price(g) }.sum
  end

  def self.part_2(input)
    return 0
  end
end
