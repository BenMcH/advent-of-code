require "parallel"

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

    return wins.map { |w| w + "A" }
  end

  def self._str_paths(str)
    @cache ||= {}

    return @cache[str] if @cache.key?(str)
    np = str.split("\n").map(&:chars)
    np_paths = {}
    keys = np.flatten.filter { |c| c != " " }
    keys.each do |a|
      keys.each do |b|
        np_paths[a + b] = paths(np, a, b)
      end
    end

    @cache[str] = np_paths.freeze
  end

  def self.numpad
    _str_paths("789\n456\n123\n 0A")
  end

  def self.keypad
    _str_paths(" ^A\n<v>")
  end

  def self.solve(kp_paths, pattern)
    pattern = pattern.chars

    solutions = kp_paths["A" + pattern[0]]

    pattern.each_cons(2) do |a, b|
      ab = kp_paths[a + b]

      solutions = solutions.flat_map do |s|
        ab.map { |p| s + p }
      end
    end

    solutions
  end

  def self.part_1(input)
    input = input.split("\n")

    input = input.map do |line|
      solutions = solve(numpad, line)

      opt = Float::INFINITY
      solutions = solutions.map do |sol|
        len = 0
        sol = "A" + sol
        sol.chars.each_cons(2) do |a, b|
          len += length_at_depth(a, b)
        end

        opt = [opt, len].min
      end

      opt * line[0..-2].to_i
    end.sum
  end

  def self.length_at_depth(a, b, depth = 2)
    kp = keypad[a + b]
    if depth == 1
      return kp[0].length
    end
    @lengths ||= {}
    key = a + b + depth.to_s
    if @lengths.key?(key)
      return @lengths[key]
    end

    opt = Float::INFINITY
    kp.each do |option|
      len = 0
      option = "A" + option

      option.chars.each_cons(2) do |a, b|
        len += length_at_depth(a, b, depth - 1)
      end

      opt = [opt, len].min
    end

    @lengths[key] = opt
  end

  def self.part_2(input)
    input = input.split("\n")

    input = input.map do |line|
      solutions = solve(numpad, line)

      opt = Float::INFINITY
      solutions = solutions.map do |sol|
        len = 0
        sol = "A" + sol
        sol.chars.each_cons(2) do |a, b|
          len += length_at_depth(a, b, 25)
        end

        opt = [opt, len].min
      end

      opt * line[0..-2].to_i
    end.sum
  end
end
