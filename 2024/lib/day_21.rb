class Day21
  Position = Struct.new(:x, :y)

  def self.paths(keypad, start, end_p)
    start_pos = nil

    keypad.each_with_index do |row, y|
      row.each_with_index do |col, x|
        if col == start
          start_pos = Position.new(x, y)
        end
      end
    end

    queue = [
      [start_pos, ""],
    ]

    win_l = Float::INFINITY
    wins = []

    while queue.length > 0
      pos, path = queue.shift

      if pos.x < 0 || pos.y < 0 || pos.x > keypad[0].length - 1 || pos.y > keypad.length - 1
        next
      end

      if keypad[pos.y][pos.x] == " "
        next
      end

      break if path.length > win_l

      keypad_val = keypad[pos.y][pos.x]
      if keypad_val == end_p
        wins << path
        win_l = path.length if path.length < win_l
        next
      end

      queue << [Position.new(pos.x + 1, pos.y), path + ">"]
      queue << [Position.new(pos.x - 1, pos.y), path + "<"]
      queue << [Position.new(pos.x, pos.y + 1), path + "v"]
      queue << [Position.new(pos.x, pos.y - 1), path + "^"]
    end

    return wins
  end

  def self.numpad = "789\n456\n123\n 0A".split("\n").map(&:chars)

  def self.keypad = " ^A\n<v>".split("\n").map(&:chars)

  def self.solve(kp_paths, pattern)
    pattern = pattern.chars

    solutions = kp_paths["A#{pattern[0]}"].map { |p| p + "A" }

    pattern.each_cons(2) do |a, b|
      ab = kp_paths["#{a}#{b}"].map { |p| p + "A" }

      solutions = solutions.flat_map do |s|
        ab.map { |p| s + p }
      end
    end

    solutions
  end

  def self.part_1(input)
    np = numpad
    kp = keypad
    np_paths = {}
    kp_paths = {}

    # paths(np, "2", "9")

    keys = np.flatten.filter { |c| c != " " }

    keys.each do |a|
      keys.each do |b|
        np_paths["#{a}#{b}"] = paths(np, a, b)
      end
    end

    keys = kp.flatten.filter { |c| c != " " }

    keys.each do |a|
      keys.each do |b|
        kp_paths["#{a}#{b}"] = paths(kp, a, b)
      end
    end

    input = input.split("\n")

    input = input.map do |line|
      solutions = solve(np_paths, line)

      2.times do
        solutions = solutions.flat_map do |s|
          solve(kp_paths, s)
        end

        min_l = solutions.map(&:length).min
        solutions = solutions.filter { |s| s.length == min_l }
      end

      solutions[0].length * line[0..-2].to_i
    end.sum

    # solutions
    # paths(np, "A", "A")
  end

  def self.part_2(input)
    return 0
  end
end
