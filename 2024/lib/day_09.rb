Memory = Struct.new(
  :id,
  :size
)

class Day09
  def self.parse(input)
    input.chars.map.with_index do |num, index|
      if index % 2 == 0
        Memory.new(index / 2, num.to_i)
      else
        Memory.new(-1, num.to_i)
      end
    end
  end

  def self.combine_memory(input, potential_changes)
    potential_changes = potential_changes.sort.reverse

    for idx in potential_changes
      next if idx < 1 || idx > input.length - 2
      imo, i, ipo = input[idx - 1], input[idx], input[idx + 1]

      if idx > 0 && imo.id == i.id
        imo.size += i.size
        input.delete_at(idx)
      elsif idx < input.length - 1 && ipo.id == i.id
        i.size += ipo.size
        input.delete_at(idx + 1)
      end
    end
  end

  def self.compact(input, allow_fragmentation = true)
    free_idx = 0
    loop do
      free_idx += 1 while free_idx < input.length - 1 && input[free_idx].id != -1

      return input if free_idx >= input.length - 1

      non_free_idx = input.rindex do |m|
        m.id != -1
      end

      free = input[free_idx]
      non_free = input[non_free_idx]

      if free.size > non_free.size
        free.size = free.size - non_free.size
        input.insert(free_idx, non_free.dup)
        non_free.id = -1
      elsif free.size == non_free.size
        free.id = non_free.id
        non_free.id = -1
      elsif allow_fragmentation
        input.insert(non_free_idx, free.dup)
        free.id = non_free.id
        non_free.size = non_free.size - free.size
      end

      combine_memory(input, [free_idx, free_idx + 1, non_free_idx, non_free_idx + 1])
    end
  end

  def self.checksum(input)
    i = 0
    total = 0
    input.each do |m|
      j = i + m.size - 1 # Range end (inclusive)
      _total = (j - i + 1) * (i + j) / 2 # Correct range sum formula
      i = j + 1 # Move to the next range start
      total += _total * m.id if m.id >= 0
    end

    total
  end

  def self.part_1(input)
    start = Time.now
    input = parse(input)
    input = compact(input)

    checksum(input)
  end

  def self.compact_files(input)
    frees = input.map.with_index { |m, i| [m, i] }.select { |m, i| m.id == -1 }
    idx = input.length
    loop do
      return input if idx == 0
      idx -= 1
      idx -= 1 while idx > 0 && input[idx].id == -1

      item = input[idx]
      free = frees.find do |free, i|
        free.size >= item.size && i < idx
      end

      next unless free
      free_cell, free_idx = free

      if free_cell.size == item.size
        free_cell.id = item.id
        item.id = -1
        free[1] = idx
        # frees.append([item, idx])
      else
        free_cell, free_idx = free
        free_cell.size -= item.size
        free[1] += item.size
        input.insert(free_idx, item.dup)
        item.id = -1
      end
      combine_memory(input, [free_idx, free_idx + 1, idx, idx + 1])
      frees = input.map.with_index { |m, i| [m, i] }.select { |m, i| m.id == -1 }
    end
  end

  def self.part_2(input)
    input = parse(input)

    input = compact_files(input)

    checksum(input)
  end
end
