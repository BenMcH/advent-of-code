class Day06
  def self.part_1(input : String) : Int64
    lines = input.split("\n").map(&.split(/\s+/).reject(&.empty?))
    
    sum = 0i64
    
    lines.reject(&.empty?).transpose.each do |problem|
    
      *numbers, operator = problem
      
      case operator
      when "*"
        product = numbers.map(&.to_i64).reduce(1i64) do |acc, n|
          acc * n
        end
        sum += product
      when "+"
        total = numbers.map(&.to_i64).sum
        sum += total
      end
    end


    sum
  end

  def self.part_2(input : String) : Int64
    lines = input.split("\n").reject(&.empty?)
    
    split_lines = [] of Int32
    lines[-1].each_char.with_index do |char, index|
      if char == '*' || char == '+'
        split_lines << index - 1
      end
    end
    
    signs = lines[-1].split(/\s+/).reject(&.empty?)
    
    sum = 0i64

    signs.each_with_index do |sign, i|
      end_index = if i + 1 < split_lines.size
        split_lines[i + 1]
      else
        -1
      end
      line_segment = lines[0..-2].map do |line|
        line[split_lines[i] + 1 .. end_index].chars
      end
      
      nums = AdventOfCodeHelpers.rotate_ccw(line_segment).map(&.join.strip).reject(&.empty?).map(&.to_i64)
      
      case sign[0]
      when '*'
        sum += nums.reduce(1i64) do |acc, n|
          acc * n
        end
      when '+'
        sum += nums.sum
      end
    end
    

    sum
  end
end
