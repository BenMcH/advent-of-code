class Day14
  Robot = Struct.new(:x, :y, :dx, :dy)

  def self.parse(input)
    input.scan(/-?\d+/).each_slice(4).map do |x, y, dx, dy|
      Robot.new(x.to_i, y.to_i, dx.to_i, dy.to_i)
    end
  end

  def self.print_robots(r_hash, max_x, max_y)
    str = ""
    (0..max_y).each do |y|
      (0..max_x).each do |x|
        str << (r_hash[[x, y]])
      end
      str << "\n\n"
    end

    str
  end

  def self.step(robots, max_x, max_y)
    r_hash = Hash.new(" ")
    robots.each do |robot|
      robot.x = (robot.x + robot.dx) % max_x
      robot.y = (robot.y + robot.dy) % max_y

      r_hash[[robot.x, robot.y]] = "#"
    end

    r_hash
  end

  def self.part_1(input, max_x = 101, max_y = 103)
    input = parse(input)

    100.times do
      step(input, max_x, max_y)
    end

    quadrant_counts = [0, 0, 0, 0]

    lower_x = max_x / 2
    lower_y = max_y / 2

    input.each do |robot|
      if robot.x < lower_x && robot.y < lower_y
        quadrant_counts[0] += 1
      elsif robot.x > lower_x && robot.y < lower_y
        quadrant_counts[1] += 1
      elsif robot.x < lower_x && robot.y > lower_y
        quadrant_counts[2] += 1
      elsif robot.x > lower_x && robot.y > lower_y
        quadrant_counts[3] += 1
      end
    end

    quadrant_counts.reduce(:*)
  end

  def self.part_2(input)
    robots = parse(input)
    10000.times do |n|
      r_hash = step(robots, 101, 103)
      str = print_robots(r_hash, 101, 103)

      if str.include?("###########")
        return n + 1
      end
    end
  end
end
