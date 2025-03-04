nums = File.read('resources/input-24').strip.split("\n").map(&:to_i)

def find_ideal(nums, groups)
  target = nums.sum / groups
  nums = nums.sort.reverse

  stacks = [
    [0, nums, []]
  ]

  possible = []
  min_len = Float::INFINITY

  while stacks.any?
    num, nums, lst = stacks.shift
    
    next if nums.empty? || lst.count >= min_len
    
    next_num = nums.shift
    
    stacks << [num, nums.dup, lst]

    if num + next_num == target
      possible << lst + [next_num]
      if possible[-1].count <= min_len
        min_len = possible[-1].count
      end
    else
      stacks << [num + next_num, nums.dup, lst + [next_num]]
    end
  end

  possible.filter { |lst| lst.count == min_len }.map { |lst| lst.reduce(:*) }.min
end

p find_ideal(nums, 3)
p find_ideal(nums, 4)
