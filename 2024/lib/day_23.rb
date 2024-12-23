require "set"

class Day23
  def self.parse(input)
    connections = {}

    input.split("\n").each do |line|
      a, b = line.split("-")

      connections[a] ||= Set.new
      connections[b] ||= Set.new

      connections[a] << b
      connections[b] << a
    end

    connections
  end

  def self.part_1(input)
    connections = parse(input)

    cliques = Set.new

    connections.each do |a, b_arr|
      b_arr.each do |b|
        c_arr = connections[b]

        c_arr.each do |c|
          if connections[c].include?(a)
            clique = [a, b, c].sort

            cliques << clique if clique.any? { |x| x.start_with?("t") }
          end
        end
      end
    end

    cliques.length
  end

  def self.part_2(input)
    return 0
  end
end
