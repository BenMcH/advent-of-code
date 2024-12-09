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

  def self.compact(input)
    free_idx = -1
    loop do
      free_idx += 1 while free_idx < input.length - 1 && input[free_idx].id != -1

      return input if free_idx >= input.length - 1

      non_free_idx = input.rindex { |m| m.id != -1 }

      free = input[free_idx]
      non_free = input[non_free_idx]

      if free.size > non_free.size
        free.size = free.size - non_free.size
        input.insert(free_idx, non_free.dup)
        non_free.id = -1
      elsif free.size == non_free.size
        free.id = non_free.id
        non_free.id = -1
      else
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

    p "Time: #{Time.now - start}"

    p input.length

    checksum(input)
  end
  def self.part_2(input)
    input = parse(input)
    # input = compact(input)

    checksum(input)
  end
end
