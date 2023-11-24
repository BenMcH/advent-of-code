numbers = [6,13,1,15,2,0]

def play_game(numbers, goal)
    cache = {}
    numbers.each.with_index{|num, i| cache[num] = i}
    (goal - numbers.length).times do
        number = numbers[-1]
        idx = cache[number] || numbers.length - 1

        num = numbers.length - 1 - idx
        cache[number] = numbers.length - 1
        numbers << num
    end
end

play_game(numbers, 2020)
p numbers[-1]

play_game(numbers, 30000000)
p numbers[-1]
