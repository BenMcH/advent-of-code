typedef Sue = Map<String, int>;

RegExp sueMatcher =
    RegExp(r'Sue (\d+): (\w+): (\d+), (\w+): (\d+), (\w+): (\d+)');

partOne(String input) {
  var lines = input.split('\n').where((element) => element.isNotEmpty);

  List<Sue> sues = [];

  for (var line in lines) {
    var match = sueMatcher.firstMatch(line);
    Sue sue = {};

    sue['name'] = int.parse(match!.group(1)!);
    sue[match.group(2)!] = int.parse(match.group(3)!);
    sue[match.group(4)!] = int.parse(match.group(5)!);
    sue[match.group(6)!] = int.parse(match.group(7)!);

    sues.add(sue);
  }

  Sue referenceSue = {
    "children": 3,
    "cats": 7,
    "samoyeds": 2,
    "pomeranians": 3,
    "akitas": 0,
    "vizslas": 0,
    "goldfish": 5,
    "trees": 3,
    "cars": 2,
    "perfumes": 1,
  };

  var eligibleSues = sues.where((sue) {
    return sue.keys.every((key) =>
        !referenceSue.containsKey(key) || referenceSue[key] == sue[key]);
  });

  return eligibleSues.first['name'];
}

partTwo(String input) {
  var lines = input.split('\n').where((element) => element.isNotEmpty);

  List<Sue> sues = [];

  for (var line in lines) {
    var match = sueMatcher.firstMatch(line);
    Sue sue = {};

    sue['name'] = int.parse(match!.group(1)!);
    sue[match.group(2)!] = int.parse(match.group(3)!);
    sue[match.group(4)!] = int.parse(match.group(5)!);
    sue[match.group(6)!] = int.parse(match.group(7)!);

    sues.add(sue);
  }

  Sue referenceSue = {
    "children": 3,
    "cats": 7,
    "samoyeds": 2,
    "pomeranians": 3,
    "akitas": 0,
    "vizslas": 0,
    "goldfish": 5,
    "trees": 3,
    "cars": 2,
    "perfumes": 1,
  };

  var eligibleSues = sues.where((sue) => sue.keys.every((key) {
        var referenceSueHasKey = referenceSue.containsKey(key);

        if (!referenceSueHasKey) return true;

        if (["cats", "trees"].contains(key)) {
          return sue[key]! > referenceSue[key]!;
        }

        if (["pomeranians", "goldfish"].contains(key)) {
          return sue[key]! < referenceSue[key]!;
        }

        return referenceSue[key] == sue[key];
      }));

  return eligibleSues.first['name'];
}
