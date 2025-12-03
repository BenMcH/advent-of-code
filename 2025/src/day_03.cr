class Day03
  def self.max_line(line : Array(Int64), depth = 2) : Int64
    n = line.size
    current = line.map_with_index { |digit, i| {i, digit} }

    (depth - 1).times do
      by_pos = Hash(Int32, Int64).new

      current.each do |pos, value|
        ((pos + 1)...n).each do |next_pos|
          new_value = value * 10 + line[next_pos]
          by_pos[next_pos] = new_value if !by_pos.has_key?(next_pos) || new_value > by_pos[next_pos]
        end
      end

      current = by_pos.to_a
    end

    current.map { |_, val| val }.max
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
