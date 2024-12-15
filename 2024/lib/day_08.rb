class Day08
  def self.parse(input)
    input = input.split("\n").map(&:chars)

    nodes = {}

    input.each_with_index do |row, i|
      row.each_with_index do |col, x|
        if col.downcase.match(/[a-z0-9]/)
          nodes[[i, x]] = col
        end
      end
    end

    return input, nodes.keys.group_by { |k| nodes[k] }
  end

  def self.make_antinodes(nodes, num_to_make = 1)
    locs = []
    nodes.combination(2).each do |a, b|
      dx = a[0] - b[0]
      dy = a[1] - b[1]

      a, b = [a, b].sort_by { |x| x[0] }
      a = a.dup
      b = b.dup

      dx, dy = -dx, -dy if dx < 0

      if num_to_make > 1
        locs << a.dup
        locs << b.dup
      end

      for i in 1..num_to_make
        a[0] -= dx
        a[1] -= dy
        b[0] += dx
        b[1] += dy

        locs << a.dup
        locs << b.dup
      end
    end

    locs.uniq
  end

  def self.part_1(input)
    input, nodes = parse(input)

    n = []
    nodes.map do |k, v|
      n = n + make_antinodes(v)
    end

    n = n.uniq.filter do |loc|
      loc[0] >= 0 && loc[0] < input.length && loc[1] >= 0 && loc[1] < input[0].length
    end

    n.length
  end

  def self.part_2(input)
    input, nodes = parse(input)

    n = []
    nodes.map do |k, v|
      n = n + make_antinodes(v, input.length + 5)
    end

    n = n.uniq.filter do |loc|
      loc[0] >= 0 && loc[0] < input.length && loc[1] >= 0 && loc[1] < input[0].length
    end

    n.length
  end
end
