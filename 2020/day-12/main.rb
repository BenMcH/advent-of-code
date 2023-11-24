require 'gnuplot'

directions = File.read('./data.txt').split.map{|a| [a[0].downcase.to_sym, a[1..-1].to_i]}

N = [0, 1]
S = [0, -1]
E = [1, 0]
W = [-1, 0]

pos = [0, 0]
direction = [1, 0]

directions.each do |d|
    instruction, amount = d

    case instruction
        when :f then pos = pos.map.with_index{|x, i| x + direction[i] * amount}
        when :n then pos[1] += amount
        when :s then pos[1] -= amount
        when :e then pos[0] += amount
        when :w then pos[0] -= amount
        when :l then (amount / 90).times do direction = direction == E ? N : direction == N ? W : direction == W ? S : E end
        when :r then (amount / 90).times do direction = direction == E ? S : direction == S ? W : direction == W ? N : E end
    end
end

p pos.map(&:abs).sum

pos = [0, 0]
waypoint = [10, 1]

def move_waypoint(waypoint, deg)
    (deg / 90).times do waypoint[0], waypoint[1] = -waypoint[1], waypoint[0] end
end

places = [[pos[0]], [pos[1]]]

directions.each do |d|
    instruction, amount = d

    case instruction
        when :f
            pos = pos.map.with_index{|x, i| x + waypoint[i] * amount}
            places[0] << pos[0]
            places[1] << pos[1]
        when :n then waypoint[1] += amount
        when :s then waypoint[1] -= amount
        when :e then waypoint[0] += amount
        when :w then waypoint[0] -= amount
        when :l then move_waypoint(waypoint, amount)
        when :r then move_waypoint(waypoint, 360 - amount)
    end
end

p pos.map(&:abs).sum

# Visualization
Gnuplot.open do |gp|
  Gnuplot::Plot.new( gp ) do |plot|
    plot.data << Gnuplot::DataSet.new( places ) do |ds|
      ds.with = "linespoints"
    end
  end
end
