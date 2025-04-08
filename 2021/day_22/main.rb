input = File.readlines("./input.txt", chomp: true)

Cuboid = Struct.new(:x, :y, :z, :on) do
  def intersect(other)
    x1 = [x.first, other.x.first].max
    x2 = [x.last, other.x.last].min
    y1 = [y.first, other.y.first].max
    y2 = [y.last, other.y.last].min
    z1 = [z.first, other.z.first].max
    z2 = [z.last, other.z.last].min

    return nil if x1 > x2 || y1 > y2 || z1 > z2

    Cuboid.new(x1..x2, y1..y2, z1..z2, !on)
  end

  def volume
    (x.size) * (y.size) * (z.size) * (on ? 1 : -1)
  end
end

def parse_input(input, limit: false)
  input.map do |line|
    on = line.start_with?("on")
    nums = line.scan(/-?\d+/).map(&:to_i)
    x = nums[0]..nums[1]
    y = nums[2]..nums[3]
    z = nums[4]..nums[5]

    if limit
      next if x.end < -50 || x.begin > 50
      next if y.end < -50 || y.begin > 50
      next if z.end < -50 || z.begin > 50

      x = [x.begin, -50].max..[x.end, 50].min
      y = [y.begin, -50].max..[y.end, 50].min
      z = [z.begin, -50].max..[z.end, 50].min
    end

    Cuboid.new(x, y, z, on)
  end.compact
end

def reboot(steps)
  cuboids = []

  steps.each do |new_cuboid|
    cuboids += cuboids.map { |c| c.intersect(new_cuboid) }.compact
    cuboids << new_cuboid if new_cuboid.on
  end

  cuboids.sum(&:volume)
end

# Part 1
p1_steps = parse_input(input, limit: true)
puts "Part 1: #{reboot(p1_steps)}"

# Part 2
p2_steps = parse_input(input)
puts "Part 2: #{reboot(p2_steps)}"
