require "z3"

class Day10
  struct Input
    property pattern : Array(Int32)
    property buttons : Array(Tuple(Int32, Array(Int32)))
    property joltage : Array(Int32)

    def initialize(@pattern, @buttons, @joltage)
    end

    private def create_solver_with_limit(buttons : Array(Z3::IntExpr), max_total : Int32?) : Z3::Solver
      solver = Z3::Solver.new

      @buttons.size.times.each do |i|
        button_var = buttons[i]
        button_cells = @buttons[i][1]

        min_joltage = button_cells.zip(@joltage).map do |affects, joltage|
          affects == 1 ? joltage : 999
        end.min

        solver.assert button_var >= 0
        solver.assert button_var <= min_joltage
      end

      @joltage.size.times.each do |cell_idx|
        affecting_buttons = [] of Z3::IntExpr
        @buttons.size.times.each do |btn_idx|
          if @buttons[btn_idx][1][cell_idx] == 1
            affecting_buttons << buttons[btn_idx]
          end
        end

        if affecting_buttons.empty?
          solver.assert Z3::IntSort[0] == @joltage[cell_idx]
        else
          sum = Z3::IntSort[0]
          affecting_buttons.each do |btn|
            sum = sum + btn
          end
          solver.assert sum == @joltage[cell_idx]
        end
      end

      if max_total
        total = Z3::IntSort[0]
        buttons.each do |btn|
          total = total + btn
        end
        solver.assert total <= max_total
      end

      solver
    end

    def solve_z3
      buttons = @buttons.size.times.map { |i| Z3.int("b_#{i}") }.to_a

      solver = create_solver_with_limit(buttons, nil)
      return 0 unless solver.satisfiable?

      upper = buttons.sum { |b| solver.model.eval(b).to_i }
      lower = 0
      best = upper

      while lower < upper
        mid = (lower + upper) // 2
        test_solver = create_solver_with_limit(buttons, mid)

        if test_solver.satisfiable?
          best = mid
          upper = mid
        else
          lower = mid + 1
        end
      end

      best
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
    input.lines.sum { |line| Input.parse(line).solve_z3 }
  end
end
