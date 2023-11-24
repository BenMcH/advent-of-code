import 'dart:math';

typedef Replacements = Map<String, List<String>>;

Replacements parseReplacements(String input,
    {List<int> regexGroups = const [1, 2]}) {
  var regex = RegExp(r'(\w+) => (\w+)');
  var lines = input.split('\n');

  Replacements replacements = {};

  for (var line in lines) {
    var match = regex.firstMatch(line);
    var groups = match?.groups(regexGroups);

    if (groups != null) {
      var key = groups[0];
      var val = groups[1];

      var arr = replacements[key!] ??= [];

      arr.add(val!);
    }
  }

  return replacements;
}

Iterable<String> replace(String input, Replacements replacements) {
  Set<String> options = {};

  replacements.forEach((key, replacementList) {
    var matches = key.allMatches(input);

    for (var match in matches) {
      for (var replacement in replacementList) {
        var newStr =
            "${input.substring(0, match.start)}$replacement${input.substring(match.end)}";

        options.add(newStr);
      }
    }
  });

  var returnVal = options.toList();

  returnVal.sort((a, b) => a.length.compareTo(b.length));

  return returnVal;
}

int partOne(String input) {
  var parts = input.split('\n\n');
  var replacements = parseReplacements(parts[0]);
  var str = parts[1];

  var options = replace(str, replacements);

  return options.length;
}

int pathLength(String option, Replacements replacements,
    {int iteration = 0, Set<String>? seen}) {
  const target = 'e';

  seen ??= {};

  if (option == target) return iteration;

  Set<String> newOptions = replace(option, replacements).toSet();

  newOptions.removeAll(seen);

  seen.addAll(newOptions);

  for (var newOption in newOptions) {
    var result = pathLength(newOption, replacements,
        iteration: iteration + 1, seen: seen);

    if (result > 0) return result;
  }

  return -1;
}

int partTwo(String input) {
  var parts = input.split('\n\n');
  var replacements = parseReplacements(parts[0], regexGroups: [2, 1]);

  return pathLength(parts[1].trim(), replacements);
}
