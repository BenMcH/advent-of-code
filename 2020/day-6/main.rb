groups = File.read('./data.txt').split("\n\n")

puts groups.map{|group| group.gsub(/[^a-z]/, '')}.map(&:chars).map(&:uniq).map(&:length).reduce(&:+)
puts groups.map {|group| group.split.map(&:chars).map(&:uniq).reduce(&:&).length}.reduce(&:+)
