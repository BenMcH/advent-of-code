Effect = Struct.new(:name, :cost, :turns_left, :damage, :armor, :mana, :heal)

effects = [
  Effect.new(:magic_missile, 53, 0, 4, 0, 0, 0),
  Effect.new(:drain, 73, 0, 2, 0, 0, 2),
  Effect.new(:shield, 113, 6, 0, 7, 0, 0),
  Effect.new(:poison, 173, 6, 3, 0, 0, 0),
  Effect.new(:recharge, 229, 5, 0, 0, 101, 0)
]

Stats = Struct.new(:hp, :mana, :mana_spent, :effects, :damage)

states = [[
    Stats.new(50, 500, 0, [], 0),
    { hp: 55 },
    0
]]

min = Float::INFINITY

while states.any?
  me, boss, turn = states.shift
  next if me.mana_spent >= min

  # Deep copy to avoid mutation issues
  me = Stats.new(me.hp, me.mana, me.mana_spent, me.effects.map(&:dup), me.damage)
  boss = boss.dup

  armor = 0
  new_effects = []

  # Apply active effects
  me.effects.each do |effect|
    me.hp += effect.heal
    me.mana += effect.mana
    armor += effect.armor
    boss[:hp] -= effect.damage
    effect.turns_left -= 1
    new_effects << effect if effect.turns_left > 0
  end

  # Check if boss is dead
  if boss[:hp] <= 0
    min = [min, me.mana_spent].min
    next
  end

  me.effects = new_effects

  if turn.even? # Player's turn
    available = effects.select do |effect|
      effect.cost <= me.mana && !me.effects.any? { |e| e.name == effect.name }
    end

    if available.empty?
      next # Player loses
    end

    new_states = available.map do |effect|
      _me = Stats.new(me.hp, me.mana - effect.cost, me.mana_spent + effect.cost, me.effects.map(&:dup), me.damage)
      _me.effects << effect.dup
      [_me, boss.dup, turn + 1]
    end

    states.concat(new_states)
  else # Boss's turn
    me.hp -= [8 - armor, 1].max

    states << [me, boss, turn + 1] if me.hp > 0
  end
end

puts min

states = [[
    Stats.new(50, 500, 0, [], 0),
    { hp: 55 },
    0
]]

min = Float::INFINITY

while states.any?
  me, boss, turn = states.shift
  next if me.mana_spent >= min

  # Deep copy to avoid mutation issues
  me = Stats.new(me.hp, me.mana, me.mana_spent, me.effects.map(&:dup), me.damage)
  boss = boss.dup

  armor = 0
  new_effects = []

  # Apply active effects
  me.effects.each do |effect|
    me.hp += effect.heal
    me.mana += effect.mana
    armor += effect.armor
    boss[:hp] -= effect.damage
    effect.turns_left -= 1
    new_effects << effect if effect.turns_left > 0
  end

  # Check if boss is dead
  if boss[:hp] <= 0
    min = [min, me.mana_spent].min
    next
  end

  me.effects = new_effects

  if turn.even? # Player's turn
    me.hp -= 1
    next if me.hp <= 0
    available = effects.select do |effect|
      effect.cost <= me.mana && !me.effects.any? { |e| e.name == effect.name }
    end

    if available.empty?
      next # Player loses
    end

    new_states = available.map do |effect|
      _me = Stats.new(me.hp, me.mana - effect.cost, me.mana_spent + effect.cost, me.effects.map(&:dup), me.damage)
      _me.effects << effect.dup
      [_me, boss.dup, turn + 1]
    end

    states.concat(new_states)
  else # Boss's turn
    me.hp -= [8 - armor, 1].max

    states << [me, boss, turn + 1] if me.hp > 0
  end
end

puts min
