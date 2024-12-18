class Day18
  def self.parse(input, size)
    arr = Hash.new("#")
    (0..size).each do |y|
      (0..size).each do |x|
        arr[[y, x]] = '.'
      end
    end
    
    nums = input.scan(/\d+/).map(&:to_i)

    return arr, nums
  end
  
  def self.print_grid(input)
    input.each do |row|
      
      puts row.join("")
    end
  end
  
  def self.neighbors(cell)
    y, x = cell

    [
      [y - 1, x],
      [y + 1, x],
      [y, x - 1],
      [y, x + 1]
    ]
  end

  def self.part_1(input, size = 70, fallen = 1024)
    input, nums = parse(input, size)
    
    nums.first(fallen*2).each_slice(2) do |x, y|
      input[[y,x]] = '#'
    end
    loc = [0,0]
    target = [size, size]

    distances = Hash.new(Float::INFINITY)
    distances[loc] = 0

    queue = [loc]

    while queue.length > 0
      a = queue.pop
      n = neighbors(a)
      dist = distances[a]

      n.each do |l|
        y, x = l

        next if input[[y,x]] == '#'

        if distances[l] > dist + 1
          distances[l] = dist + 1
          queue << l
        end  
      end

    end
    

    return distances[target]
  end
  
  def self.part_2(input, size = 70, fallen = 1024)
    input, nums = parse(input, size)

    while fallen > 0
      y, x, *nums = nums

      input[[y, x]] = '#'
      fallen -= 1
    end

    while nums.length
      dy, dx = nums[0], nums[1]

      nums = nums.drop(2)
      input[[dy,dx]] = '#'

      loc = [0,0]
      target = [size, size]

      distances = Hash.new(Float::INFINITY)
      distances[loc] = 0

      queue = [loc]

      while queue.length > 0
        a = queue.pop
        n = neighbors(a)
        dist = distances[a]

        break if distances[target] != Float::INFINITY

        n.each do |l|
          y, x = l

          next if input[[y,x]] == '#'

          if distances[l] > dist + 1
            distances[l] = dist + 1
            queue << l
          end  
        end
      end

      if distances[target] == Float::INFINITY
        return "#{dy},#{dx}"
      end
    end
  end
end
