input = File.readlines('./resources/input-10')

robots = Hash.new{ |h,k| h[k] = [] }

outputs = Hash.new{ |h,k| h[k] = [] }

rules = {}

input.each do |line|
  numbers = line.scan(/\d+/).map(&:to_i)
  line = line.split(/\s+/)

  if line[0] == "value"
    # value X goes to bot Y
    robots[numbers[1]] << numbers[0]
  else
    # bot X gives low to Y and high to Z
    rules[numbers[0]] = [line[5], numbers[1], line[10], numbers[2]]
  end
end

loop do
  if robots.find { |k, v| v.length > 2 }
    raise "oh no"
  end
  robot, vals = robots.find { |k, v| v.length == 2 }

  robots.delete(robot)

  low_place, low, high_place, high = rules[robot]

  low_val, high_val = vals.minmax

  if low_val == 17 && high_val == 61
    puts robot
  end

  low_place = low_place == "bot" ? robots[low] : outputs[low]
  low_place << low_val

  high_place = high_place == "bot" ? robots[high] : outputs[high]
  high_place << high_val

  if outputs[0].length > 0 && outputs[1].length > 0 && outputs[2].length > 0
    break
  end
end


p outputs[0][0] * outputs[1][0] * outputs[2][0]
