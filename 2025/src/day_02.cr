class Day02
  def self.part_1(input : String) : Int64
    sum = 0i64
    ranges = input.split(",").map(&.split("-").map(&.to_i64)).map do |arr|
      (arr[0]..arr[1]).to_a
    end.flatten.sort.each do |num|
      num_s = num.to_s
      half = num_s[0..(num_s.size/2).to_i - 1]
      num_s = "0" if num_s != "#{half}#{half}"

      sum += num_s.to_i64
    end

    sum
  end

  def self.part_2(input : String) : Int64
    sum = 0i64
    invalid_regex = /^(\d+)\1+$/
    ranges = input.split(",").map(&.split("-").map(&.to_i64)).map do |arr|
      (arr[0]..arr[1]).to_a
    end.flatten.sort.each do |num|
      num_s = num.to_s
      if num_s.match(invalid_regex) == nil
        num_s = "0"
      end
      sum += num_s.to_i64
    end

    sum
  end
end
