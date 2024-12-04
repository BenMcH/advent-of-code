class Day04
  def self.check_row(row)
    count = 0
    row.each_cons(4) do |a, b, c, d|
      str = "#{a}#{b}#{c}#{d}"
      count += 1 if str == "XMAS" || str == "SAMX"
    end

    count
  end

  def self.check_diagonal(multi_dim_array, row, col)
    if row > multi_dim_array.length - 4 || col > multi_dim_array[0].length - 4
      return 0
    end 

    a = multi_dim_array[row][col]
    b = multi_dim_array[row + 1][col + 1]
    c = multi_dim_array[row + 2][col + 2]
    d = multi_dim_array[row + 3][col + 3]

    str = "#{a}#{b}#{c}#{d}"

    if "XMAS" == str || "SAMX" == str
      return 1
    end

    return 0
  end

  def self.check_reverse_diagonal(multi_dim_array, row, col)
    if row > multi_dim_array.length - 4 || col < 3
      return 0
    end 

    a = multi_dim_array[row][col]
    b = multi_dim_array[row + 1][col - 1]
    c = multi_dim_array[row + 2][col - 2]
    d = multi_dim_array[row + 3][col - 3]

    str = "#{a}#{b}#{c}#{d}"

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

    multi_dim_array.transpose.each do |row|
      count += check_row(row)
    end

    for row in 0...multi_dim_array.length
      for col in 0...(multi_dim_array[0].length)
        count += check_diagonal(multi_dim_array, row, col)
        count += check_reverse_diagonal(multi_dim_array, row, col)
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
      [mda[2][0], mda[2][2]]
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
      rows = multi_dim_array[row..row+2]
      for col in 0...(multi_dim_array[0].length)
        box = rows.map{|row| row[col..col+2]}

        next unless box.length == 3 && box[1][1] == "A"

        if is_xmas(box)
          count += 1
        end
      end
    end 

    return count
  end
end
