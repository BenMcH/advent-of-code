forest_map = File.read('./data.txt').split("\n")

def get_trees_encountered(tree_map, right, down)
    new_arr = tree_map.select.with_index{|row, idx| (idx) % down === 0}
    trees_encountered_part_1 = new_arr.each_with_index.map do |row, idx|
        row[(idx * right) % row.length] == '#' ? 1 : 0
    end.reduce(&:+)
end

trees_encountered_part_1 = get_trees_encountered(forest_map, 3, 1)

puts trees_encountered_part_1

product_of_five_toboggan_runs = [
    [1, 1],
    [3, 1],
    [5, 1],
    [7, 1],
    [1, 2]
].map{|pair| get_trees_encountered(forest_map, pair[0], pair[1])}.reduce(&:*)

puts product_of_five_toboggan_runs
