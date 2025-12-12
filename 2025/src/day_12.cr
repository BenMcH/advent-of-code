class Day12
  def self.part_1(input : String)
    *presents, boxes = input.split("\n\n")

    presents = presents.map do |present|
      present.count("#")
    end

    boxes.lines.count do |box|
      size, reqs = box.split(": ")

      size = size.split("x").map(&.to_i).product.to_i128

      reqs_map = reqs.split.map_with_index do |r, i|
        (r.to_i * presents[i]).to_i128
      end

      size >= reqs_map.sum.to_i64
    end
  end

  def self.part_2(input : String)
    "Merry Christmas!"
  end
end
