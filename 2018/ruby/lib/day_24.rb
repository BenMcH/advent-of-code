input = File.read('./inputs/day24.txt')

# Define a struct for representing a group of units
Unit = Struct.new(
  :id,                # Unique identifier
  :team,              # "Immune System" or "Infection"
  :unit_count,        # Number of units in this group
  :hit_points,        # Hit points per unit
  :attack_damage,     # Attack damage per unit
  :attack_type,       # Type of attack (fire, cold, radiation, etc.)
  :initiative,        # Initiative (determines attack order)
  :weaknesses,        # Array of attack types this group is weak to
  :immunities,        # Array of attack types this group is immune to
) do
  def effective_power
    unit_count * attack_damage
  end
  
  def damage_to(target)
    return 0 if target.immunities.include?(attack_type)
    return effective_power * 2 if target.weaknesses.include?(attack_type)
    effective_power
  end
  
  def take_damage(damage)
    units_lost = [damage / hit_points, unit_count].min
    self.unit_count -= units_lost
    units_lost
  end
  
  def alive?
    unit_count > 0
  end
  
  def to_s
    "#{team}-#{id}"
    # "#{team} Group #{id}: #{unit_count} units with #{hit_points} HP, #{attack_damage} #{attack_type} damage, initiative #{initiative}" +
    # (weaknesses.empty? ? "" : ", weak to #{weaknesses.join(', ')}") +
    # (immunities.empty? ? "" : ", immune to #{immunities.join(', ')}")
  end
end

# Parse the input file into Unit objects
def parse_input(input)
  units = []
  current_team = nil
  id_counter = { "Immune System" => 1, "Infection" => 1 }
  
  input.each_line do |line|
    line = line.strip
    next if line.empty?
    
    # Detect team change
    if line == "Immune System:" || line == "Infection:"
      current_team = line.chomp(":")
      next
    end
    
    # Parse unit details
    if current_team && line =~ /(\d+) units each with (\d+) hit points(?: \(([^)]+)\))? with an attack that does (\d+) (\w+) damage at initiative (\d+)/
      unit_count = $1.to_i
      hit_points = $2.to_i
      modifiers = $3 || ""
      attack_damage = $4.to_i
      attack_type = $5
      initiative = $6.to_i
      
      # Parse weaknesses and immunities
      weaknesses = []
      immunities = []
      
      if !modifiers.empty?
        modifiers.split("; ").each do |part|
          if part.start_with?("weak to ")
            weaknesses = part.sub("weak to ", "").split(", ")
          elsif part.start_with?("immune to ")
            immunities = part.sub("immune to ", "").split(", ")
          end
        end
      end

      units << Unit.new(
        id_counter[current_team],
        current_team,
        unit_count,
        hit_points,
        attack_damage,
        attack_type,
        initiative,
        weaknesses,
        immunities
      )
      
      id_counter[current_team] += 1
    end
  end
  
  units
end

units = parse_input(input)

OPPOSITE_TEAM = {
  "Immune System" => "Infection",
  "Infection" => "Immune System"
}

def fight(units)
  units.sort_by! { |unit| [-unit.effective_power, -unit.initiative] }
  live_ones = units.select(&:alive?)

  attacks = {}
  teams = live_ones.group_by(&:team)

  puts(teams.size)
  return false if teams.size < 2

  # select targets
  live_ones.each do |attacker|
    attackable = teams[OPPOSITE_TEAM[attacker.team]].select { |target| !attacks.values.include?(target) }

    target = attackable.max_by { |t| [attacker.damage_to(t), t.effective_power, t.initiative] }

    if target && attacker.damage_to(target) > 0
      p "#{attacker.team} #{attacker.id} -> #{target.id}"
      attacks["#{attacker.team}#{attacker.id}"] = target
    end
  end

  # attack phase

  live_ones.sort_by { |unit| -unit.initiative }.each do |attacker|
    target = attacks["#{attacker.team}#{attacker.id}"]

    next unless target
    damage = attacker.damage_to(target)
    units_lost = target.take_damage(damage)

    puts "#{attacker.team} group #{attacker.id} attacks defending group #{target.id}, killing #{units_lost} units"
  end

  puts "===================="

  return true
end


rounds = 0

rounds += 1 while fight(units)

sum = units.select(&:alive?).map(&:unit_count).sum

puts "Units remaining: #{sum}"
