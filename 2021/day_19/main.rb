require 'set'

Point = Struct.new(:x, :y, :z) do
  def +(other)
    Point.new(x + other.x, y + other.y, z + other.z)
  end

  def -(other)
    Point.new(x - other.x, y - other.y, z - other.z)
  end

  def ==(other)
    x == other.x && y == other.y && z == other.z
  end

  def hash
    [x, y, z].hash
  end

  def eql?(other)
    self == other
  end

  def manhatten(other)
    (x - other.x).abs + (y - other.y).abs + (z - other.z).abs
  end
end

def generate_orientations
  axes = [:x, :y, :z]
  perms = axes.permutation.to_a
  signs = [-1, 1].repeated_permutation(3).to_a

  orientations = []

  perms.each do |perm|
    signs.each do |sx, sy, sz|
      # Build a lambda that takes a Point and reorders + signs its components
      orientations << lambda { |p|
        coords = { x: p.x, y: p.y, z: p.z }
        Point.new(
          coords[perm[0]] * sx,
          coords[perm[1]] * sy,
          coords[perm[2]] * sz
        )
      }
    end
  end

  # Now filter only valid right-handed ones (determinant = +1)
  # We'll do that by checking the cross product of the first two axes equals the third
  orientations.select do |rot|
    a = rot.call(Point.new(1, 0, 0))
    b = rot.call(Point.new(0, 1, 0))
    c = rot.call(Point.new(0, 0, 1))

    cross = Point.new(
      a.y * b.z - a.z * b.y,
      a.z * b.x - a.x * b.z,
      a.x * b.y - a.y * b.x
    )

    cross == c
  end
end

@orientation_procs = generate_orientations()

class Scanner
  attr_reader :rows, :id, :loc
  attr_writer :loc

  def initialize(id, rows)
    @id = id
    @rows = rows.map do |row|
      Point.new(*row.split(",").map(&:to_i))
    end
    @loc = Point.new(0, 0, 0)
  end

  def rows=(n_rows)
    @rows = n_rows 
  end

end

scanner_inputs = File.read("./input.txt").split("\n\n")

scanners = scanner_inputs.map do |section|
  id, *lines = section.split("\n")
  id = id[/\d+/].to_i

  Scanner.new(id, lines)
end

@cached_scanners = {}

def reoriented_beacons(scanner)
  if @cached_scanners[scanner].nil?
    @cached_scanners[scanner] = @orientation_procs.map do |rotation|
      scanner.rows.map { |p| rotation.call(p) }
    end
  end

  return @cached_scanners[scanner]
end

good = [scanners[0]]

scanners = scanners[1..]

while scanners.any?
  pts = good.flat_map(&:rows).to_set

  scanners.reject! do |scanner|
    matched = false

    reoriented_beacons(scanner).each do |orientation|
      offsets = Hash.new(0)

      orientation.each do |cand|
        pts.each do |known|
          offset = known - cand
          offsets[offset] += 1
        end
      end

      # Find the most common offset (how many points align at that translation)
      best_offset, count = offsets.max_by { |_, v| v }

      if count >= 12
        # Translate scanner into global space
        scanner.loc = best_offset
        scanner.rows = orientation.map { |pt| pt + best_offset }
        good << scanner
        matched = true
        break
      end
    end

    matched
  end
end

p good.flat_map(&:rows).to_set.length

locs = good.map(&:loc)

p locs.combination(2).map{|a, b| a.manhatten(b)}.max
