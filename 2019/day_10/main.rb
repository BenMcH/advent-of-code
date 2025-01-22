require "set"
input = File.read("./input.txt").strip.split("\n").map(&:chars)

max = 0
loc = nil

asteroids = Set.new

rows = input.length
columns = input[0].length

input.each_with_index do |row, i|
  row.each_with_index do |c, j|
    next if c == "."
    
    asteroids << [i, j]
  end
end

asteroids.each do |a|
  count = 0

  ay, ax = a

  angles = Set.new

  asteroids.each do |b|
    next if a == b
    by, bx = b
    angles << Math.atan2(ay - by, ax - bx)
  end

  if angles.length > max
    max = angles.length

    loc = a
  end
end

puts "Part 1: #{max}"

asteroids.delete(loc)

removed = 0

asteroids = asteroids.group_by { |a| (Math.atan2(loc[0] - a[0], loc[1] - a[1]) * (180.0 / Math::PI)) % 360 }

def dist(point1, point2)
  y1, x1 = point1
  y2, x2 = point2

  Math.sqrt((x2 - x1)**2 + (y2 - y1)**2)
end

asteroids.each do |_k, v|
  v.sort_by! { |_v| dist(loc, _v) }
end

keys = asteroids.keys.sort
degrees_index = keys.index(90)

loop do
  key = keys[degrees_index]
  if asteroids[key].any?
    val = asteroids[key].shift

    removed += 1

    if removed == 200
      puts "Part 2: #{val[1] * 100 + val[0]}"
      break
    end
  end

  degrees_index = (degrees_index + 1) % keys.length
end

