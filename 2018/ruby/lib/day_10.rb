class Day10
  Node = Struct.new(:x, :y, :dx, :dy) do
    def step
      self.x += dx
      self.y += dy
    end
  end

  def self.size(nodes)
    x = [Float::INFINITY, -Float::INFINITY]
    y = [Float::INFINITY, -Float::INFINITY]

    nodes.each do |n|
      x[0] = n.x if n.x < x[0]
      x[1] = n.x if n.x > x[1]
      y[0] = n.y if n.y < y[0]
      y[1] = n.y if n.y > y[1]
    end

    return x[1] - x[0] + y[1] - y[0]
  end

  def self.print_message(nodes)
    x = [Float::INFINITY, -Float::INFINITY]
    y = [Float::INFINITY, -Float::INFINITY]
    hash = Hash.new(" ")

    nodes.each do |n|
      x[0] = n.x if n.x < x[0]
      x[1] = n.x if n.x > x[1]
      y[0] = n.y if n.y < y[0]
      y[1] = n.y if n.y > y[1]

      hash[[n.y, n.x]] = "#"
    end
    min_x, max_x = x
    min_y, max_y = y


    str = ""
    (min_y..max_y).each do |y|
      (min_x..max_x).each do |x|
        str << hash[[y, x]]
      end
      str << "\n"
    end

    puts str
  end

  def self.part_1(input)
    input = input.scan(/-?\d+/).map(&:to_i).each_slice(4).map do |lst|
      Node.new(*lst)
    end

    min = Float::INFINITY
    min_t = Float::INFINITY
    nodes = input
    t = 0
    loop do
      input.each {|i| i.step}

      s = size(input)
      t += 1
      if min > s
        min = s
        min_t = t
        nodes = input.map(&:dup)
      elsif min < Float::INFINITY
        break
      end
    end
    p min_t

    print_message(nodes)
  end
end
