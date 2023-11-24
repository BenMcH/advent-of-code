import 'dart:math';

Map<String, Map<String, int>> parseInput(String input) {
  var lines = input.split('\n');

  Map<String, Map<String, int>> directions = {};

  var regex = RegExp(r'(\w+) to (\w+) = (\d+)');
  for (var line in lines) {
    var match = regex.firstMatch(line);

    if (match == null) continue;

    var start = match.group(1);
    var end = match.group(2);
    var distance = match.group(3);

    if (start == null || end == null || distance == null) {
      continue;
    }

    var startMap = directions[start] ??= {};
    var endMap = directions[end] ??= {};

    startMap[end] = int.parse(distance);
    endMap[start] = int.parse(distance);
  }

  return directions;
}

int walk(Map<String, Map<String, int>> maps, String current,
    {Set<String>? visited, int Function(int, int) reducer = min}) {
  visited ??= {};

  visited.add(current);

  if (visited.length == maps.keys.length) {
    return 0;
  }

  var dests = maps[current];

  if (dests == null) {
    throw "Missing Destination";
  }

  var keys = dests.keys.toSet().difference(visited);

  var scores = keys.map((e) {
    Set<String> innerVisited = Set.from(visited!);
    return dests[e]! + walk(maps, e, visited: innerVisited, reducer: reducer);
  });

  return scores.reduce(reducer);
}

partOne(String input) {
  var directions = parseInput(input);

  var scores = directions.keys.map((e) => walk(directions, e));

  return scores.reduce(min);
}

partTwo(String input) {
  var directions = parseInput(input);

  var scores = directions.keys.map((e) => walk(directions, e, reducer: max));

  return scores.reduce(max);
}
