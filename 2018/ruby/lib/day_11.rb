class Day11
  def self.build_grid(input)
    i = []

    300.times do |_y|
      y = _y + 1
      arr = []
      300.times do |_x|
        x = _x + 1
        rack_id = x + 10
        power_level = rack_id * y + input
        power_level *= rack_id

        power_level %= 1000
        power_level /= 100

        power_level -= 5
        arr << power_level
      end

      i << arr
    end

    i
  end

  def self.largest_section(i, size = 3)
    coord = [-1, -1]
    max = -Float::INFINITY

    i.each_with_index do |row, y|
      next if y > i.length - size - 1
      row.each_with_index do |val, x|
        next if x > i[y].length - size - 1

        pow = i[y...y + size].sum { |j| j[x...x + size].sum }

        if pow > max
          max = pow
          coord[0] = x + 1
          coord[1] = y + 1
        end
      end
    end

    return coord, max
  end

  def self.part_1(input)
    input = input.to_i

    i = build_grid(input)

    coord, _ = largest_section(i)

    coord.join(",")
  end

  def self.part_2(input)
    input = input.to_i

    i = build_grid(input)
    max = -Float::INFINITY
    max_coord = ""

    (1..300).each do |size|
      coord, _max = largest_section(i, size)

      p _max

      if _max > max
        max = _max
        max_coord = [*coord, size].join(",")
      elsif _max < 0
        break
      end
      # p size
    end

    max_coord
  end
end
