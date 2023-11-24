Ingredent = Struct.new :ingredients, :allergens

ingredient_list = File.read("./data.txt").split("\n").map do |list|
    ingredients, contains = /(.*)\(contains (.*)\)/.match(list).captures
    ingredients = ingredients.split(" ")
    contains = contains.split(", ")
    Ingredent.new ingredients, contains
end


allergen_mapping = {}

c = -1
list = ingredient_list

all_allergens = ingredient_list.flat_map(&:allergens).uniq
all_ingredients = ingredient_list.flat_map(&:ingredients).uniq

all_allergens.each do |allergen|
    ingredients = ingredient_list.select{|ingredient| ingredient.allergens.include?(allergen)}.map(&:ingredients).reduce(:&)

    allergen_mapping[allergen] = ingredients
end

allergens = allergen_mapping.to_a

until allergens.count{|a| a[1].kind_of? Array} == 0
    allergens = allergens.map{|a| [a[0], a[1].length == 1 ? a[1][0] : a[1]]}

    claimed = allergens.select{|a| a[1].kind_of? String}.map{|a| a[1]}

    allergens.select{|a| a[1].kind_of? Array}.each do |a|
        a[1] -= claimed
    end
end

non_allergen_foods = all_ingredients - allergens.map{|a| a[1]}

p ingredient_list.flat_map(&:ingredients).count{|i| non_allergen_foods.include?(i)}

p allergens.sort_by{|a| a[0]}.map{|a| a[1]}.join(',')
