Moon = Struct.new(:x, :y, :z, :dx, :dy, :dz) do
  def initialize(*)
    super
    self.dx = 0
    self.dy = 0
    self.dz = 0
  end

  def move
    self.x += self.dx
    self.y += self.dy
    self.z += self.dz
  end

  def potential_energy = self.x.abs + self.y.abs + self.z.abs
  def kinetic_energy = self.dx.abs + self.dy.abs + self.dz.abs

  def to_s
    "#{self.x},#{self.y},#{self.z},#{self.dx},#{self.dy},#{self.dz}"
  end
end

moons = File.readlines("./input.txt").map do |line|
  Moon.new(*line.scan(/-?\d+/).map(&:to_i))
end

_moons = moons.map(&:dup)

1000.times do
  moons.product(moons).each do |a, b|
    next if a == b

    diff = a.x - b.x
    if diff > 0
      a.dx -= 1
    elsif diff < 0
      a.dx += 1
    end

    diff = a.y - b.y
    if diff > 0
      a.dy -= 1
    elsif diff < 0
      a.dy += 1
    end

    diff = a.z - b.z
    if diff > 0
      a.dz -= 1
    elsif diff < 0
      a.dz += 1
    end
  end

  moons.each &:move
end

p moons.map { |m| m.potential_energy * m.kinetic_energy }.sum


def find_period(moons)
  _moons = moons.map(&:dup)
  period = 0

  loop do
    period += 1

    moons.product(moons).each do |a, b|
      next if a == b

      diff = a[0] - b[0]
      if diff > 0
        a[1] -= 1
      elsif diff < 0
        a[1] += 1
      end
    end

    moons.each { |a| a[0] += a[1] }

    return period if moons == _moons
  end
end

x = _moons.map{ |moon| [moon.x, moon.dx] }
x_period = find_period(x)
y = _moons.map{ |moon| [moon.y, moon.dy] }
y_period = find_period(y)
z = _moons.map{ |moon| [moon.z, moon.dz] }
z_period = find_period(z)

p x_period.lcm(y_period).lcm(z_period)
