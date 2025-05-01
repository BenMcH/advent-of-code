Star = Struct.new(:x, :y, :z, :a) do
  def manhattan_distance(other)
    (x - other.x).abs + (y - other.y).abs + (z - other.z).abs + (a - other.a).abs
  end
end

stars = File.readlines('./inputs/day25.txt', chomp: true).map do |line|
  Star.new(*line.split(',').map(&:to_i)) 
end

constellations = []

until stars.empty?
  current_constellation = [stars.shift]
  
  changed = true
  while changed
    changed = false
    
    stars.each_with_index do |star, index|
      if current_constellation.any? { |c_star| c_star.manhattan_distance(star) <= 3 }
        current_constellation << star
        stars[index] = nil
        changed = true
      end
    end
    
    stars.compact!
  end
  
  constellations << current_constellation
end

puts "Number of constellations: #{constellations.size}"
