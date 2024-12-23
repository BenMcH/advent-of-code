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
    return if checked.include?(clique)
    checked << clique
    set = clique.map { |x| connections[x] }.reduce(&:&)

    set.each do |x|
      n_clique = clique.dup
      n_clique << x

      expand_clique(n_clique, connections, checked)
    end
  end

  def self.part_2(input)
    connections = parse(input)

    cliques = size_three_groups(connections)

    checked = Set.new

    cliques.each do |clique|
      expand_clique(Set.new(clique), connections, checked)
    end

    checked.max_by { |c| c.length }.to_a.sort.join(",")
  end
end
