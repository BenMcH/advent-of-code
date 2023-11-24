hand_one, hand_two = File.read('./data.txt').split("\n\n").map{|hand| hand.split("\n")[1..-1].map(&:to_i)}

h1 = hand_one.dup
h2 = hand_two.dup

until h1.length == 0 || h2.length == 0
    p1, *p1_l = h1
    p2, *p2_l = h2

    if p1 > p2
        h1 = [*p1_l, p1, p2]
        h2 = p2_l
    else
        h2 = [*p2_l, p2, p1]
        h1 = p1_l
    end
end

hand = h1.length > 0 ? h1 : h2

p hand.reverse.map.with_index{|n, i| n * (i + 1)}.sum

def recursive_combat(h1, h2)
    cache = []
    until h1.empty? || h2.empty?
        hash = [h1, h2].hash
        return [1, h1] if cache.include? hash
        cache << hash
        p1 = h1.shift
        p2 = h2.shift

        winner = if p1 <= h1.size && p2 <= h2.size
            recursive_combat(h1.take(p1), h2.take(p2))[0]
        else
            p1 > p2 ? 1 : 2
        end
        a, b = winner == 1 ? [[p1, p2], []] : [[], [p2, p1]]
        h1 = h1.concat(a)
        h2 = h2.concat(b)
    end

    return h2.empty? ? [1, h1] : [2, h2]
end


p recursive_combat(hand_one, hand_two)[1].reverse.map.with_index{|n, i| n * (i + 1)}.sum
