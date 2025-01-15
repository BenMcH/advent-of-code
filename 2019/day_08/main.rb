input = File.read("./input.txt").strip.chars.map(&:to_i)

width = 25
height = 6

layers = input.each_slice(width * height)
input = layers.min_by { |layer| layer.count(0) }

p input.count(1) * input.count(2)

image = [2] * height * width

layers.each do |layer|
  layer.each_with_index do |v, i|
    image[i] = v if image[i] == 2
  end
end

str = ""
height.times do |i|
  width.times do |j|
    ch = image[i * width + j]

    if ch == 0
      str += " "
    else
      str += "#"
    end
  end

  str += "\n"
end

puts str
