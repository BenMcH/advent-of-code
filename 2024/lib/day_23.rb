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

  def self.size_three_groups(connections)
    cliques = Set.new

    connections.each do |a, b_arr|
      b_arr.each do |b|
        c_arr = connections[b]

        c_arr.each do |c|
          if connections[c].include?(a)
            clique = [a, b, c].sort

            cliques << clique
          end
        end
      end
    end

    cliques
  end

  def self.part_1(input)
    connections = parse(input)

    size_three_groups(connections).filter { |clique| clique.any? { |x| x.start_with?("t") } }.length
  end

  def self.expand_clique(clique, connections, checked)
    set, *rest = clique.map { |x| connections[x] }
    possibilities = []
    return possibilities if checked.include?(clique)

    checked << clique

    # p "Before: #{set.length}"
    rest.each do |x|
      set = set.intersection(x)
    end
    # p "After: #{set.length}"

    set.each do |x|
      n_clique = Set.new(clique)
      n_clique << x

      possibilities << n_clique

      c = expand_clique(n_clique, connections, checked)
      possibilities << c if c != []
    end

    checked
  end

  def self.part_2(input)
    connections = parse(input)

    cliques = size_three_groups(connections)

    checked = Set.new

    cliques.each do |clique|
      expand_clique(Set.new(clique), connections, checked)
    end

    checked.max_by do |c|
      c.length
    end.to_a.sort.join(",")
  end
end
