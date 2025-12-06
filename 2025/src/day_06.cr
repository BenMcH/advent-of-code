class Day06
  def self.do_math(numbers : Array(Int64), operator : String) : Int64
    operator == "*" ? numbers.product : numbers.sum
  end

  def self.part_1(input : String) : Int64
    lines = input.split("\n").map(&.split(/\s+/).reject(&.empty?))
    
    lines.reject(&.empty?).transpose.sum do |column|
      *numbers, operator = column
      do_math(numbers.map(&.to_i64), operator)
    end
  end

  def self.part_2(input : String) : Int64
    lines = input.split("\n").reject(&.empty?)
    
    operator_positions = lines[-1].each_char.with_index.select do |char, _|
      char == '*' || char == '+'
    end.map { |_, index| index - 1 }.to_a
    
    operators = lines[-1].split(/\s+/).reject(&.empty?)
    number_rows = lines[0..-2]
    
    operators.each_with_index.sum do |operator, i|
      start_pos = operator_positions[i] + 1
      end_pos = operator_positions[i + 1]? || -1
      
      column_chars = number_rows.map { |line| line[start_pos..end_pos].chars }
      numbers = AdventOfCodeHelpers.rotate_ccw(column_chars)
        .map(&.join.strip)
        .reject(&.empty?)
        .map(&.to_i64)
      
      do_math(numbers, operator)
    end
  end
end
