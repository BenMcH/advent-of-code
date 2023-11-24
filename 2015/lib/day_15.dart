import 'dart:math';

RegExp ingredientMatch = RegExp(
    r'(\w+): capacity (-?\d+), durability (-?\d+), flavor (-?\d+), texture (-?\d+), calories (-?\d+)');

class Ingredient {
  String name;
  int capacity, durability, flavor, texture, calories;

  Ingredient(this.name, this.capacity, this.durability, this.flavor,
      this.texture, this.calories);

  Ingredient tablespoons(int tbsp) {
    return Ingredient(name, capacity * tbsp, durability * tbsp, flavor * tbsp,
        texture * tbsp, calories * tbsp);
  }
}

List<Ingredient> parseInput(String input) {
  var lines = input.split('\n');

  List<Ingredient> lookup = [];

  for (var element in lines) {
    var match = ingredientMatch.firstMatch(element);

    if (match == null) {
      continue;
    }

    var name = match.group(1)!;
    var capacity = int.parse(match.group(2)!);
    var durability = int.parse(match.group(3)!);
    var flavor = int.parse(match.group(4)!);
    var texture = int.parse(match.group(5)!);
    var calories = int.parse(match.group(6)!);

    lookup
        .add(Ingredient(name, capacity, durability, flavor, texture, calories));
  }

  return lookup;
}

List<List<Ingredient>> possibilities(
    List<Ingredient> ingredients, int amountLeft,
    {int ingredientIndex = 0}) {
  if (ingredientIndex == ingredients.length - 1) {
    return [
      [ingredients[ingredientIndex].tablespoons(amountLeft)]
    ];
  }
  List<List<Ingredient>> combos = [];

  for (var i = 0; i <= amountLeft; i++) {
    var item = ingredients[ingredientIndex].tablespoons(i);

    if (i < amountLeft) {
      var ingredientMaps = possibilities(ingredients, amountLeft - i,
          ingredientIndex: ingredientIndex + 1);

      for (var list in ingredientMaps) {
        list.add(item);
      }

      combos.addAll(ingredientMaps);
    } else {
      combos.add([item]);
    }
  }

  return combos;
}

partOne(String input, {bool partTwo = false, int goalCalories = 0}) {
  var ingredients = parseInput(input);

  var p = possibilities(ingredients, 100);

  return p.map((e) {
    // int capacity, durability, flavor, texture, calories;
    if (partTwo) {
      var calories = e.map((i) => i.calories).reduce((a, b) => a + b);
      if (calories != goalCalories) {
        return 0;
      }
    }

    var ans = e.map((i) => i.capacity).reduce((a, b) => a + b);
    if (ans <= 0) return 0;
    ans *= e.map((i) => i.durability).reduce((a, b) => a + b);
    if (ans <= 0) return 0;
    ans *= e.map((i) => i.flavor).reduce((a, b) => a + b);
    if (ans <= 0) return 0;
    ans *= e.map((i) => i.texture).reduce((a, b) => a + b);
    if (ans <= 0) return 0;

    return ans;
  }).reduce(max);
}
