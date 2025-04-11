require 'algorithms'

min_x = min_y = 0
max_x = max_y = -Float::INFINITY

input = File.read("./input.txt")
class State
  attr_accessor :hall, :rooms, :energy, :visited

  def initialize(input="", part_2=false)
    letters = input.scan(/[A-Z]/)

    @hall = [nil] * 11
    @rooms = part_2 == false ? [
      [letters[0],letters[4]],
      [letters[1],letters[5]],
      [letters[2],letters[6]],
      [letters[3],letters[7]],
    ] : [
      [letters[0], "D", "D", letters[4]],
      [letters[1], "C", "B", letters[5]],
      [letters[2], "B", "A", letters[6]],
      [letters[3], "A", "C", letters[7]],
    ]
    @energy = 0
  end

  def to_s
    [@hall, @rooms, @energy].to_s 
  end

  def dup
    d = State.new
    d.hall = @hall.dup
    d.rooms = @rooms.map(&:dup)
    d.energy = @energy

    d
  end

  def ==(other)
   other.hall == @hall &&
   other.rooms == @rooms
  end

  def eql?(other)
    self == other
  end

  def hash
    [@hall, @rooms].hash
  end

  def path_clear?(a, b)
    step = a < b ? 1 : -1
    (a + step).step(b, step).all? { |pos| @hall[pos].nil? }
  end

  def next_states
    states = []

    # For each room
    @rooms.each_with_index do |stack, room_idx|
      next if stack.all? { |a| a == "ABCD"[room_idx] } # Already correct

      amphipod = stack.find { |a| a } # Topmost non-nil
      next if amphipod.nil?
      pos_in_stack = stack.index(amphipod)
      next if amphipod == "ABCD"[room_idx] && pos_in_stack == 1
      hall_pos = 2 + room_idx * 2 # room position in hall

      # Try all hallway positions
      [0,1,3,5,7,9,10].each do |target_hall_pos|
        next unless path_clear?(hall_pos, target_hall_pos)

        steps = pos_in_stack + 1 + (hall_pos - target_hall_pos).abs
        energy = steps * ENERGY[amphipod]

        new_state = self.dup
        new_state.hall[target_hall_pos] = amphipod
        new_state.rooms[room_idx][pos_in_stack] = nil
        new_state.energy += energy

        states << new_state
      end
    end

    @hall.each_with_index do |a, i|
      next unless a # skip empty

      dest = ROOM_INDEX[a]
      room = @rooms[dest]
      next unless room.all? { |r| r.nil? || r == a }
      next unless path_clear?(i, 2 + dest * 2)

      depth = room.rindex(nil)
      steps = (i - (2 + dest * 2)).abs + depth + 1
      energy = steps * ENERGY[a]

      new_state = self.dup
      new_state.hall[i] = nil
      new_state.rooms[dest][depth] = a
      new_state.energy += energy

      states << new_state
    end

    states
  end

  def goal?
    @rooms.zip("ABCD".chars).all? { |room, expected|
      room.all? { |a| a == expected }
    }
  end
end

(min_y..max_y).each do |y|
  (min_x..max_x).each do |x|
    print input[[x,y]]
  end
  puts ""
end

ENERGY = {
  "A" => 1,
  "B" => 10,
  "C" => 100,
  "D" => 1000
}

ROOM_INDEX = {
  "A" => 0,
  "B" => 1,
  "C" => 2,
  "D" => 3
}

initial_state = State.new(input)
cost_so_far = { initial_state => 0 }
pq = Containers::PriorityQueue.new
pq.push(initial_state, 0)

while !pq.empty?
  state = pq.pop

  next if cost_so_far[state] < state.energy # already have cheaper path

  if state.goal?
    puts "Minimum energy: #{state.energy}"
    break
  end

  state.next_states.each do |next_state|
    if cost_so_far[next_state].nil? || next_state.energy < cost_so_far[next_state]
      cost_so_far[next_state] = next_state.energy
      pq.push(next_state, -next_state.energy)
    end
  end
end

initial_state = State.new(input, true)
cost_so_far = { initial_state => 0 }
pq = Containers::PriorityQueue.new
pq.push(initial_state, 0)

while !pq.empty?
  state = pq.pop

  next if cost_so_far[state] < state.energy # already have cheaper path

  if state.goal?
    puts "Minimum energy: #{state.energy}"
    break
  end

  state.next_states.each do |next_state|
    if cost_so_far[next_state].nil? || next_state.energy < cost_so_far[next_state]
      cost_so_far[next_state] = next_state.energy
      pq.push(next_state, -next_state.energy)
    end
  end
end
