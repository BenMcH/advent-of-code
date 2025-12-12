class Day11
  def self.part_1(input : String) : Int32
    map = {} of String => Array(String)

    input.each_line do |line|
      key, rest = line.split(": ")
      map[key] = rest.split(" ")
    end
    
    paths = [] of Array(String)
    to_visit = [] of Array(String)
    to_visit << ["you"]
    
    while to_visit.size > 0
      path = to_visit.shift

      _paths = map[path[-1]]

      _paths.each do |p|
        if p == "out"
          paths << path
          next
        end

        unless path.includes?(p)
          to_visit << [*path, p]
        end
      end
    end
    paths.size
  end

  def self.part_2(input : String) : Int32
    0
  end
end
