class Day10
  struct Input
    property pattern : Array(Int32)
    property buttons : Array(Tuple(Int32, Array(Int32)))
    property joltage : Array(Int32)

    def initialize(@pattern, @buttons, @joltage)
    end

    def self.parse(line : String) : Input
      line = line.gsub(/[\[\]\(\)\{\}]/, "")

      pattern_str, *buttons_strs, joltage_str = line.split(" ")

      pattern = pattern_str.chars.map { |c| c == '#' ? 1 : 0 }

      buttons = buttons_strs.map do |btn_str|
        map = [0] * pattern.size
        c = 0
        btn_str.split(",").each do |idx_str|
          idx = idx_str.to_i
          map[idx] = 1
          c += 1
        end
        {c, map}
      end.sort_by(&.first)

      joltage = joltage_str.split(",").map(&.to_i)

      Input.new(pattern, buttons, joltage)
    end
  end

  def self.search_for_pattern(desired_pattern : Array(Int32), buttons_to_press : Array(Tuple(Int32, Array(Int32))), buttons_pressed = 0) : Int32
    to_check = [{desired_pattern, buttons_to_press, buttons_pressed}]

    while to_check.size > 0
      current_pattern, current_buttons, current_pressed = to_check.shift

      current_buttons.each do |_, array|
        next if current_buttons.size == 0

        new_pattern = current_pattern.zip(array).map { |a, b| a ^ b }

        if new_pattern.all? { |v| v == 0 }
          return current_pressed + 1
        else
          remaining_buttons = current_buttons.reject { |_, arr| arr == array }
          to_check << {new_pattern, remaining_buttons, current_pressed + 1}
        end
      end
    end
    0
  end

  def self.part_1(input : String)
    input.lines.sum do |line|
      i = Input.parse(line)

      search_for_pattern(i.pattern, i.buttons)
    end
  end

  def self.part_2(input : String) : Int32
    0
  end
end
