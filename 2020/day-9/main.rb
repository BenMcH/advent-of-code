numbers = File.read('./data.txt').split("\n").map(&:to_i)

target = numbers[25..-1].find.with_index do |number, index|
    preamble = numbers[index..index+24]
    sums = preamble.product(preamble).map{|set| set.sum}

    sums.all?{|num| num != number}
end

puts target

numbers.each.with_index do |_, index|
    numbers[index+1..-1].each.with_index do |_, another_index|
        range = index..index+another_index + 1

        if numbers[range].sum == target
            puts numbers[range].minmax.sum if numbers[range].sum == target
            break
        end
    end
end
