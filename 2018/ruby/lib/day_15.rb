#!/usr/bin/env ruby

class Unit
  attr_accessor :type, :x, :y, :hp, :attack_power, :alive

  def initialize(type, x, y, attack_power = 3)
    @type = type
    @x = x
    @y = y
    @hp = 200
    @attack_power = type == 'E' ? attack_power : 3
    @alive = true
  end

  def coords
    [y, x]
  end

  def enemy?(other)
    type != other.type
  end

  def adjacent?(other)
    (x - other.x).abs + (y - other.y).abs == 1
  end

  def reading_order_coords
    [y, x]
  end

  def to_s
    "#{type}(#{hp})"
  end
end

class BattleSimulation
  attr_reader :map, :units, :rounds, :initial_elf_count, :elf_count

  def initialize(input, elf_attack_power = 3)
    @map = []
    @units = []
    @rounds = 0
    @elf_attack_power = elf_attack_power
    
    # Parse input
    input.each_with_index do |line, y|
      row = []
      line.strip.chars.each_with_index do |char, x|
        case char
        when 'G'
          @units << Unit.new(char, x, y)
          row << '.'
        when 'E'
          @units << Unit.new(char, x, y, elf_attack_power)
          row << '.'
        else
          row << char
        end
      end
      @map << row
    end
    
    @initial_elf_count = @units.count { |u| u.type == 'E' }
    @elf_count = @initial_elf_count
  end

  def step
    # Sort units by reading order
    @units.sort_by!(&:reading_order_coords)
    
    # Each unit takes a turn
    @units.each do |unit|
      return false if combat_ended?
      next unless unit.alive
      
      # Find targets
      targets = @units.select { |u| u.alive && unit.enemy?(u) }
      return false if targets.empty?
      
      # If not in range of any target, move
      attackable = targets.select { |t| unit.adjacent?(t) }
      
      if attackable.empty?
        move(unit, targets)
        # After moving, find attackable targets again
        attackable = targets.select { |t| unit.alive && t.alive && unit.adjacent?(t) }
      end
      
      # Attack if possible
      attack(unit, attackable) unless attackable.empty?
    end
    
    # Count elves and remove dead units
    @elf_count = @units.count { |u| u.alive && u.type == 'E' }
    @units.reject! { |u| !u.alive }
    
    @rounds += 1
    true
  end

  def move(unit, targets)
    # Find all squares in range of targets
    in_range = []
    targets.each do |target|
      adjacent_squares(target.y, target.x).each do |y, x|
        in_range << [y, x] if @map[y][x] == '.' && !unit_at?(y, x)
      end
    end
    
    return if in_range.empty?
    
    # Find reachable squares and their distances
    distances = {}
    visited = {}
    queue = [[unit.y, unit.x, 0]]
    
    while !queue.empty?
      y, x, dist = queue.shift
      next if visited[[y, x]]
      visited[[y, x]] = true
      
      if in_range.include?([y, x])
        distances[[y, x]] = dist
      end
      
      adjacent_squares(y, x).each do |ny, nx|
        if @map[ny][nx] == '.' && !unit_at?(ny, nx) && !visited[[ny, nx]]
          queue << [ny, nx, dist + 1]
        end
      end
    end
    
    return if distances.empty?
    
    # Find the nearest square in range
    min_dist = distances.values.min
    nearest = distances.select { |_, d| d == min_dist }.keys.sort
    
    return if nearest.empty?
    
    # Choose the first square in reading order
    target_y, target_x = nearest.first
    
    # Find the first step towards the chosen square
    first_steps = []
    adjacent_squares(unit.y, unit.x).each do |ny, nx|
      next unless @map[ny][nx] == '.' && !unit_at?(ny, nx)
      
      # Calculate path from this step to target
      step_distances = {}
      step_visited = {}
      step_queue = [[ny, nx, 0]]
      
      while !step_queue.empty?
        sy, sx, sdist = step_queue.shift
        next if step_visited[[sy, sx]]
        step_visited[[sy, sx]] = true
        
        if [sy, sx] == [target_y, target_x]
          step_distances[[ny, nx]] = sdist
          break
        end
        
        adjacent_squares(sy, sx).each do |nsy, nsx|
          if @map[nsy][nsx] == '.' && !unit_at?(nsy, nsx) && !step_visited[[nsy, nsx]]
            step_queue << [nsy, nsx, sdist + 1]
          end
        end
      end
      
      first_steps << [ny, nx, step_distances[[ny, nx]]] if step_distances[[ny, nx]]
    end
    
    return if first_steps.empty?
    
    # Find the step that leads to the target in fewest steps
    min_step_dist = first_steps.map { |_, _, d| d }.compact.min
    return unless min_step_dist
    
    best_steps = first_steps.select { |_, _, d| d == min_step_dist }
    best_step = best_steps.sort_by { |y, x, _| [y, x] }.first
    
    # Move the unit
    unit.y, unit.x = best_step[0], best_step[1]
  end

  def attack(unit, targets)
    # Sort targets by HP, then reading order
    target = targets.sort_by { |t| [t.hp, t.y, t.x] }.first
    
    # Attack
    target.hp -= unit.attack_power
    
    # Check if target died
    if target.hp <= 0
      target.alive = false
    end
  end

  def combat_ended?
    elf_alive = @units.any? { |u| u.alive && u.type == 'E' }
    goblin_alive = @units.any? { |u| u.alive && u.type == 'G' }
    !elf_alive || !goblin_alive
  end

  def adjacent_squares(y, x)
    [[y-1, x], [y, x-1], [y, x+1], [y+1, x]].select do |ny, nx|
      ny >= 0 && nx >= 0 && ny < @map.size && nx < @map[0].size
    end
  end

  def unit_at?(y, x)
    @units.any? { |u| u.alive && u.y == y && u.x == x }
  end

  def total_hp
    @units.select(&:alive).sum(&:hp)
  end

  def print_map
    @map.each_with_index do |row, y|
      line = row.join
      units_in_row = @units.select { |u| u.alive && u.y == y }.sort_by(&:x)
      puts "#{line} #{units_in_row.map(&:to_s).join(', ')}"
    end
    puts
  end

  def outcome
    @rounds * total_hp
  end

  def all_elves_survived?
    @elf_count == @initial_elf_count
  end

  def elves_win?
    @units.any? { |u| u.alive && u.type == 'E' } && !@units.any? { |u| u.alive && u.type == 'G' }
  end
end

def part1(input)
  simulation = BattleSimulation.new(input)
  
  loop do
    break unless simulation.step
  end
  
  simulation.outcome
end

def part2(input)
  # Use binary search to find minimum attack power
  low = 4
  high = 200  # Maximum reasonable attack power (could kill in one hit)
  result = nil
  
  while low <= high
    mid = (low + high) / 2
    puts "Trying elf attack power: #{mid}" if $DEBUG
    
    simulation = BattleSimulation.new(input, mid)
    
    # Run simulation till completion
    while simulation.step
    end
    
    if simulation.all_elves_survived? && simulation.elves_win?
      # This power works, but we want to find the minimum
      result = simulation.outcome
      high = mid - 1
    else
      # This power doesn't work, try higher
      low = mid + 1
    end
  end
  
  result
end

if $PROGRAM_NAME == __FILE__
  input = File.readlines('./inputs/day15.txt')
  puts "Part 1: #{part1(input)}"
  puts "Part 2: #{part2(input)}"
end
