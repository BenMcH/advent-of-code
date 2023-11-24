sets = File.read("./data.txt").split("mask = ").map{|set| "#{set}".split("\n")}

def init(sets)
    memory = {}
    sets.each do |set|
        mask, *rules = set

        rules.each do |rule|
            index, value = /mem\[(\d+)\] = (\d+)/.match(rule).captures
            index, value = index.to_i, value.to_i.to_s(2).rjust(36, '0')

            mask.chars.each.with_index { |m, idx| value[idx] = m unless m == 'X' }

            memory[index] = value.to_i(2)
        end
    end

    memory
end

p init(sets).values.sum

def create_indexes(mask, index)
    start, *others = mask.chars.map.with_index { |m, i| m == '1' ? [1] : m == 'X' ? [0, 1] : [index[i]] }
    start.product(*others).map(&:join)
end

def init_part_2(sets)
    memory = {}
    sets.each do |set|
        mask, *rules = set

        rules.each do |rule|
            index, value = /mem\[(\d+)\] = (\d+)/.match(rule).captures
            index, value = index.to_i.to_s(2).rjust(36, '0'), value.to_i

            create_indexes(mask, index).each { |index| memory[index.to_i(2)] = value }
        end
    end

    memory
end

p init_part_2(sets).values.sum
