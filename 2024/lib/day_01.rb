class Day01

  def self.part_1(input)
    lines = input.strip.split("\n")
    lines = lines.map{|line| line.split.map(&:to_i)}
    
    first, last = lines.map(&:first).sort, lines.map(&:last).sort
    
    distance = 0

    first.zip(last).each do |first, last|
      distance += (last - first).abs
    end
    
    distance
  end
  
  def self.part_2(input)
    lines = input.strip.split("\n")
    lines = lines.map{|line| line.split.map(&:to_i)}
    
    first, last = lines.map(&:first).sort, lines.map(&:last).sort
    
    similarity = 0

    first.each do |first|
      mult = last.count(first)
      similarity += mult * first
    end
    
    similarity
  end
end
