class Day16
  Location = Struct.new(:x, :y, :dir)

  def self.step(location)
    Location.new(location.x + location.dir[1], location.y + location.dir[0], location.dir)
  end

  def self.turn_left(loc)
    if loc.dir == [0, 1]
      Location.new(loc.x, loc.y, [-1, 0])
    elsif loc.dir == [-1, 0]
      Location.new(loc.x, loc.y, [0, -1])
    elsif loc.dir == [0, -1]
      Location.new(loc.x, loc.y, [1, 0])
    elsif loc.dir == [1, 0]
      Location.new(loc.x, loc.y, [0, 1])
    else
      raise "Unknown direction #{loc.dir}"
    end
  end

  def self.turn_right(loc)
    loc = turn_left(loc)
    loc = turn_left(loc)
    turn_left(loc)
  end

  def self.parse(input)
    input = input.split("\n").map { |line| line.chars }

    i = {}
    loc = Location.new(0, 0, [0, 1])
    end_loc = Location.new(0, 0, [0, 1])

    input.each_with_index do |row, y|
      row.each_with_index do |col, x|
        next if col == "#"

        up = Location.new(x, y, [-1, 0])
        down = Location.new(x, y, [1, 0])
        right = Location.new(x, y, [0, 1])
        left = Location.new(x, y, [0, -1])

        i[up] = Float::INFINITY
        i[down] = Float::INFINITY
        i[right] = Float::INFINITY
        i[left] = Float::INFINITY

        if col == "S"
          loc.x = x
          loc.y = y
          i[right] = 0
        end
        if col == "E"
          end_loc.x = x
          end_loc.y = y
        end
      end
    end

    return i, loc, end_loc
  end

  def self.part_1(input)
    input, start, end_loc = parse input

    locs = [start]

    min_e = Float::INFINITY

    while locs.length > 0
      loc = locs.shift

      if loc.x == end_loc.x && loc.y == end_loc.y
        min_e = [min_e, input[loc]].min
      end

      stepped = step(loc)
      if input[stepped] && input[stepped] > input[loc] + 1
        input[stepped] = input[loc] + 1
        locs << stepped
      end

      left = turn_left(loc)
      right = turn_right(loc)

      if input[left] > input[loc] + 1000
        input[left] = input[loc] + 1000
        locs << left
      end

      if input[right] > input[loc] + 1000
        input[right] = input[loc] + 1000
        locs << right
      end
    end

    min_e
  end

  def self.part_2(input)
    input, start, end_loc = parse input

    locs = [start]

    min_e = Float::INFINITY

    while locs.length > 0
      loc = locs.shift

      if loc.x == end_loc.x && loc.y == end_loc.y
        min_e = [min_e, input[loc]].min
      end

      stepped = step(loc)
      if input[stepped] && input[stepped] > input[loc] + 1
        input[stepped] = input[loc] + 1
        locs << stepped
      end

      left = turn_left(loc)
      right = turn_right(loc)

      if input[left] > input[loc] + 1000
        input[left] = input[loc] + 1000
        locs << left
      end

      if input[right] > input[loc] + 1000
        input[right] = input[loc] + 1000
        locs << right
      end
    end

    queue = [end_loc,
             turn_left(end_loc),
             turn_right(end_loc),
             turn_left(turn_left(end_loc))].filter { |loc| input[loc] == min_e }.uniq

    # p queue
    locs = [end_loc, start]
    unstep = lambda { |loc|
      Location.new(loc.x - loc.dir[1], loc.y - loc.dir[0], loc.dir)
    }

    while queue.length > 0
      loc = queue.shift

      unstepped = unstep.call(loc)

      if input[unstepped] == input[loc] - 1
        locs << loc
        queue << unstepped
      end

      left = turn_left(loc)
      if input[left] == input[loc] - 1000
        locs << left
        queue << left
      end

      right = turn_right(loc)
      if input[right] == input[loc] - 1000
        locs << right
        queue << right
      end
    end

    locs.map { |loc| loc.x * 1000 + loc.y }.uniq.count
  end
end
