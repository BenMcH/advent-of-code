class Day03
  def self.max_line(line : Array(Int64), depth = 2, curr = 0i64): Int64
    return curr if depth == 0

    max = curr * 10

    line.each_with_index do |a, i|
      n_line = line[i+1..-1]

      next if n_line.size < depth - 1

      candidate = max_line(n_line, depth - 1, curr * 10 + a)
      if candidate > max
        max = candidate
      end
    end

    max
  end


  def self.part_1(input : String) : Int64
    input.strip.split("\n").map(&.strip.split("").map(&.to_i64)).sum do |line|
      max_line(line)
    end
  end

  def self.part_2(input : String) : Int64
    input.strip.split("\n").map(&.strip.split("").map(&.to_i64)).sum do |line|
      max_line(line, 12)
    end
  end
end
