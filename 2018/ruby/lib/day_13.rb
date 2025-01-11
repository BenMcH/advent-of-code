class Day13
  Cart = Struct.new(:y, :x, :dir, :turn_counter) do
    def initialize(*)
      super
      self.turn_counter = 0
    end

    def loc = [y, x]

    def turn
      mod = self.turn_counter % 3
      if mod == 0
        self.dir = dir.turn_left
      elsif mod == 1
        self.dir = dir
      else
        self.dir = dir.turn_right
      end

      self.turn_counter += 1
    end

    def step(grid)
      #puts "Before #{y} #{x} #{dir} #{grid[[y, x]]}"
      self.y += self.dir.y
      self.x += self.dir.x
      #puts "after #{y} #{x} #{dir} #{grid[[y, x]]}"

      cell = grid[[y, x]]
      if cell == :+
        self.turn
      elsif cell == :/
        if dir.y == 0 # Moving left
          self.dir = dir.turn_left
        else # Moving up
          self.dir = dir.turn_right
        end
      elsif cell == :"\\"
        if dir.y == 0 # Moving right
          self.dir = dir.turn_right
        else # Moving down
          self.dir = dir.turn_left
        end
      elsif cell == nil
        raise "Moved into bad cell #{[y, x]}"
      end
    end
  end

  Dir = Struct.new(:y, :x) do
    def turn_left
      return Dir.new(1, 0) if x == -1
      return Dir.new(-1, 0) if x == 1
      return Dir.new(0, -1) if y == -1
      return Dir.new(0, 1) if y == 1
    end

    def turn_right
      return Dir.new(-1, 0) if x == -1
      return Dir.new(1, 0) if x == 1
      return Dir.new(0, 1) if y == -1
      return Dir.new(0, -1) if y == 1
    end
  end

  def self.print_grid(grid, carts = [])
    min_x, max_x = grid.keys.map(&:last).minmax
    min_y, max_y = grid.keys.map(&:first).minmax

    carts = carts.map {|c| [c.loc, "#"]}.to_h

    (min_y..max_y).each do |y|
      str = ""
      (min_x..max_x).each do |x|
        ch = carts[[y,x]] || grid[[y,x]] || :" "
        str << ch.to_s
      end

      puts str
    end
  end

  def self.parse(input)
    grid = {}
    carts = []
    dir_to_pipe = {
      :> => :-,
      :< => :-,
      :^ => :|,
      :v => :|,
    }
    dir_to_vec = {
      :> => Dir.new(0, 1),
      :< => Dir.new(0, -1),
      :^ => Dir.new(-1, 0),
      :v => Dir.new(1, 0),
    }
    input.split("\n").map(&:chars).each_with_index do |row, y|
      row.each_with_index do |char, x|
        char = char.to_sym
        if [:>, :<, :^, :v].include? char
          grid[[y, x]] = dir_to_pipe[char] 
          carts << Cart.new(y, x, dir_to_vec[char])
        elsif char != :" "
          grid[[y, x]] = char
        end
      end
    end

    return grid, carts
  end

  def self.part_1(input)
    input, carts = parse(input)

    loop do
      carts.sort_by!(&:loc)

      carts.each do |c|
        c.step(input)

        return c.loc.reverse.join(",") if carts.any? {|c2| c != c2 && c.loc == c2.loc }
      end
    end
  end
  
  def self.part_2(input)
    input, carts = parse(input)

    loop do
      carts.sort_by!(&:loc)
      to_remove = []

      carts.each do |c|
        next if to_remove.include?(c)
        c.step(input)

        c2 = carts.find {|c2| c != c2 &&  c.loc == c2.loc && !to_remove.include?(c2)}


        if c2
          to_remove << c
          to_remove << c2
        end
      end

      carts -= to_remove

      if to_remove.length
        # p carts.length
      end

      if carts.length == 1
        return carts[0].loc.reverse.join(",")
      end
    end
  end
end
