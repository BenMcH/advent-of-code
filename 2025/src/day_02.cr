class Day02
  def self.get_ranges(input : String)
    input.split(",").map do |str|
      a, b = str.split("-").map(&.to_i64)
      a..b
    end
  end

  def self.part_1(input : String) : Int64
    get_ranges(input).sum do |range|
      range.sum do |num|
        num.to_s.match(/^(\d+)\1$/) ? num : 0i64
      end
    end
  end

  def self.part_2(input : String) : Int64
    get_ranges(input).sum do |range|
      range.sum do |num|
        num.to_s.match(/^(\d+)\1+$/) ? num : 0i64
      end
    end
  end
end
