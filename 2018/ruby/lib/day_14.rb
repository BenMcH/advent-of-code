class Day14
  Recipe = Struct.new(:score, :left, :right) do
    def print_recipes(ending = self)
      return score.to_s if right == ending
      return "#{score} #{right.print_recipes(ending)}"
    end
  end

  def self.part_1(input)
    start = Recipe.new(3)
    end_r = Recipe.new(7, start, start)
    start.left = end_r
    start.right = end_r

    first = start
    second = end_r

    recipes = input.to_i + 10
    made = 2

    until made >= recipes do
      combo = first.score + second.score

      end_r = start.left

      if combo >= 10
        a = Recipe.new(combo / 10, end_r, nil)
        b = Recipe.new(combo % 10, a, start)
        a.right = b
        start.left = b
        end_r.right = a
        made += 2
      else
        end_r = start.left

        new_recipe = Recipe.new(combo, end_r, start)
        start.left = new_recipe
        end_r.right = new_recipe
        made += 1
      end

      (first.score + 1).times { first = first.right }
      (second.score + 1).times { second = second.right }
    end

    total = ""
    c = start
    10.times do 
      c = c.left

      total = c.score.to_s + total
    end

    total
  end
  
  def self.part_2(input)
    start = Recipe.new(3)
    end_r = Recipe.new(7, start, start)
    start.left = end_r
    start.right = end_r

    first = start
    second = end_r

    recipes = input.strip.chars.reverse
    made = 2

    loop do
      combo = first.score + second.score

      end_r = start.left

      if combo >= 10
        a = Recipe.new(combo / 10, end_r, nil)
        b = Recipe.new(combo % 10, a, start)
        a.right = b
        start.left = b
        end_r.right = a
        end_r = b
        made += 2
      else
        end_r = start.left

        new_recipe = Recipe.new(combo, end_r, start)
        start.left = new_recipe
        end_r.right = new_recipe
        end_r = new_recipe
        made += 1
      end

      (first.score + 1).times { first = first.right }
      (second.score + 1).times { second = second.right }

      loc = end_r
      offset = 0

      if loc.score != recipes[0]
        loc = loc.left 
        offset = 1
      end
      i = 0
      while i < recipes.length
        break unless loc.score.to_s == recipes[i]
        loc = loc.left
        i+=1
      end

      return made - recipes.length - offset if i == recipes.length
    end
  end
end
