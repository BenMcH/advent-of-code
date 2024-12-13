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

  def self.count_corners(plot, loc)
    up = plot[[loc[0] - 1, loc[1]]]
    down = plot[[loc[0] + 1, loc[1]]]
    left = plot[[loc[0], loc[1] - 1]]
    right = plot[[loc[0], loc[1] + 1]]
    up_left = plot[[loc[0] - 1, loc[1] - 1]]
    up_right = plot[[loc[0] - 1, loc[1] + 1]]
    down_left = plot[[loc[0] + 1, loc[1] - 1]]
    down_right = plot[[loc[0] + 1, loc[1] + 1]]

    count = 0

    count += 1 if !up && !left
    count += 1 if !down && !left
    count += 1 if !up && !right
    count += 1 if !down && !right

    count += 1 if !up_left && up && left
    count += 1 if !up_right && up && right
    count += 1 if !down_left && down && left
    count += 1 if !down_right && down && right

    return count
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
    end.flatten(1)

    perimeter = fences.length
    area = group.keys.length

    reconstructed_fence = {}

    fences.each { |f| reconstructed_fence[f] = true }

    sides = 0
    group.each do |f, _|
      sides += count_corners(group, f)
    end

    return area * perimeter, sides * area
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

    groups.map { |g| price(g)[0] }.sum
  end

  def self.part_2(input)
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

    groups.map { |g| price(g)[1] }.sum
  end
end
