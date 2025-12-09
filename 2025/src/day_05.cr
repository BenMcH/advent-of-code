class Day05
  def self.part_1(input : String) : Int32
    fresh_ingredients = [] of Range(Int64, Int64)

    fresh, available = input.split("\n\n", 2)

    fresh.lines.each do |line|
      range_parts = line.split("-", 2)
      start_range = range_parts[0].to_i64
      end_range = range_parts[1].to_i64
      fresh_ingredients << (start_range..end_range)
    end

    available_ingredients = [] of Int64
    available.lines.each do |line|
      available_ingredients << line.to_i64
    end

    available_ingredients.count do |ingredient|
      fresh_ingredients.any? do |range|
        range.includes?(ingredient)
      end
    end
  end

  def self.part_2(input : String) : Int64
    fresh_ingredients = [] of Range(Int64, Int64)

    fresh, available = input.split("\n\n", 2)

    fresh.lines.each do |line|
      range_parts = line.split("-", 2)
      start_range = range_parts[0].to_i64
      end_range = range_parts[1].to_i64
      fresh_ingredients << (start_range..end_range)
    end

    fresh_ingredients.sort_by! &.first

    current = fresh_ingredients[0]
    count = 0i64

    fresh_ingredients[1..].each do |ingredient|
      if current.includes?(ingredient.begin) || ingredient.begin <= current.end + 1
        current = current.begin..[current.end, ingredient.end].max
      else
        count += (current.end - current.begin + 1).to_i64
        current = ingredient
      end
    end

    count + (current.end - current.begin + 1)
  end
end
