import 'dart:math';

import 'package:trotter/trotter.dart';

int seatingHappiness(List<String> order, Map<String, Map<String, int>> lookup) {
  int total = 0;

  for (var i = 0; i < order.length; i++) {
    if (i == 0) {
      total += lookup[order[i]]![order.last]!;
      total += lookup[order[i]]![order[i + 1]]!;
    } else if (i == order.length - 1) {
      total += lookup[order[i]]![order.first]!;
      total += lookup[order[i]]![order[i - 1]]!;
    } else {
      total += lookup[order[i]]![order[i - 1]]!;
      total += lookup[order[i]]![order[i + 1]]!;
    }
  }

  return total;
}

Map<String, Map<String, int>> parseInput(String input) {
  var lines = input.split('\n');

  Map<String, Map<String, int>> lookup = {};

  var reg = RegExp(
      r'([A-Z]\w+) would (\w+) (\d+) happiness units by sitting next to ([A-Z]\w+)');

  for (var element in lines) {
    var match = reg.firstMatch(element);

    if (match == null) {
      continue;
    }

    var firstName = match.group(1)!;
    var dir = match.group(2)!;
    var amount = int.parse(match.group(3)!) * (dir == 'lose' ? -1 : 1);
    var secondName = match.group(4)!;

    var map = lookup[firstName] ??= {};

    map[secondName] = amount;
  }

  return lookup;
}

partOne(String input) {
  var lookup = parseInput(input);
  var perms = Permutations(lookup.length, lookup.keys.toList());

  var maxVal = 0;

  for (var perm in perms()) {
    maxVal = max(maxVal, seatingHappiness(perm, lookup));
  }

  return maxVal;
}

partTwo(String input) {
  var lookup = parseInput(input);
  lookup.forEach((key, value) {
    value['me'] = 0;
  });
  lookup['me'] = {};

  lookup.keys.forEach((element) => lookup['me']![element] = 0);
  var perms = Permutations(lookup.length, lookup.keys.toList());

  var maxVal = 0;

  for (var perm in perms()) {
    maxVal = max(maxVal, seatingHappiness(perm, lookup));
  }

  return maxVal;
}
