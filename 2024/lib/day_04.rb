require_relative "./helpers"

class Day04
  def self.check_row(row)
    row.join("").scan(/(?=(XMAS|SAMX))/).length
  end

  def self.check_diagonal(multi_dim_array, row, col)
    return 0 if multi_dim_array[row + 3].nil?

    str = ""

    for i in 0..3
      str += multi_dim_array[row + i][col + i] || ""
    end

    if "XMAS" == str || "SAMX" == str
      return 1
    end

    return 0
  end

  def self.count_xmas(multi_dim_array)
    count = 0

    multi_dim_array.each do |row|
      count += check_row(row)
    end

    rotated = AdventOfCodeHelpers.rotate_cw(multi_dim_array)
    rotated.each do |row|
      count += check_row(row)
    end

    for row in 0...multi_dim_array.length
      for col in 0...(multi_dim_array[0].length)
        count += check_diagonal(multi_dim_array, row, col)
        count += check_diagonal(multi_dim_array.reverse, row, col)
      end
    end

    count
  end

  def self.part_1(input)
    return self.count_xmas(input.strip.split("\n").map(&:chars))
  end

  def self.is_xmas(mda)
    corners = [
      [mda[0][0], mda[0][2]],
      [mda[2][0], mda[2][2]],
    ]

    return true if corners == [["M", "M"], ["S", "S"]]
    return true if corners == [["S", "M"], ["S", "M"]]
    return true if corners == [["S", "S"], ["M", "M"]]
    return true if corners == [["M", "S"], ["M", "S"]]
  end

  def self.part_2(input)
    multi_dim_array = input.strip.split("\n").map(&:chars)

    count = 0

    for row in 0...multi_dim_array.length
      rows = multi_dim_array[row..row + 2]
      for col in 0...(multi_dim_array[0].length)
        box = rows.map { |row| row[col..col + 2] }

        next unless box.length == 3 && box[1][1] == "A"

        if is_xmas(box)
          count += 1
        end
      end
    end

    return count
  end
end
