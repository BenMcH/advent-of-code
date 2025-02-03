Entry = Struct.new(:id, :is_gen)

def parse_input(input, part2 = false)
  material_ids = {}
  
  floors = []
  input.each do |line|
    items = []
    line.scan(/(\w+)(-compatible)? (generator|microchip)/) do |material, _, type|
      material_ids[material] ||= material_ids.length
      items << Entry.new(material_ids[material], type == 'generator')
    end
    floors << items
  end

  if part2
    # Add the extra items to the first floor
    material_ids['elerium'] = material_ids.length
    material_ids['dilithium'] = material_ids.length + 1
    
    floors[0] += [
      Entry.new(material_ids['elerium'], true),    # elerium generator
      Entry.new(material_ids['elerium'], false),   # elerium microchip
      Entry.new(material_ids['dilithium'], true),  # dilithium generator
      Entry.new(material_ids['dilithium'], false)  # dilithium microchip
    ]
  end
  
  floors
end

def valid_floor?(items)
  return true if items.empty?
  generators = items.select { |entry| entry.is_gen }.map(&:id)
  return true if generators.length == 0
  
  # If there are generators, each chip must have its matching generator
  items.each do |entry|
    next if entry.is_gen
    return false unless generators.include?(entry.id)
  end
  true
end

def next_states(elevator, floors)
  states = []
  current = floors[elevator]
  empty = floors[0...elevator].all?(&:empty?)
  
  # Try moving 1 or 2 items
  [1, 2].each do |count|
    current.combination(count).each do |items|
      [-1, 1].each do |dir|
        next_floor = elevator + dir
        next if next_floor < 0 || next_floor > 3
        
        # Skip moving down if all lower floors are empty
        next if dir == -1 && empty
        
        new_floors = floors.map(&:dup)
        new_floors[next_floor] += items
        new_floors[elevator] -= items
        
        next unless valid_floor?(new_floors[elevator]) && 
                   valid_floor?(new_floors[next_floor])
        
        states << [next_floor, new_floors]
      end
    end
  end
  states
end

def canonical_state(elevator, floors)
  positions = Hash.new { |h,k| h[k] = [nil, nil] }
  floors.each_with_index do |floor, floor_idx|
    floor.each do |entry|
      positions[entry.id][entry.is_gen ? 0 : 1] = floor_idx
    end
  end
  
  sorted_pos = positions.values.sort
  
  id_map = {}
  positions.each do |old_id, pos|
    id_map[old_id] = sorted_pos.index(pos)
  end
  
  new_floors = floors.map do |floor|
    floor.map { |entry| Entry.new(id_map[entry.id], entry.is_gen) }.sort_by { |e| [e.id, e.is_gen ? 1 : 0] }
  end
  
  [elevator, new_floors]
end

def solve(floors)
  seen = {}
  queue = [[0, floors, 0]]  # [elevator, floors, steps]
  
  until queue.empty?
    elevator, floors, steps = queue.shift
    
    # Goal: everything on top floor
    return steps if floors[0..2].all?(&:empty?)
    
    next_states(elevator, floors).each do |next_floor, new_floors|
      key = canonical_state(next_floor, new_floors)
      next if seen[key]
      seen[key] = true
      queue << [next_floor, new_floors, steps + 1]
    end
  end
end

input = File.readlines('./resources/input-11')

puts "Part 1: #{solve(parse_input(input))}"
puts "Part 2: #{solve(parse_input(input, true))}"
