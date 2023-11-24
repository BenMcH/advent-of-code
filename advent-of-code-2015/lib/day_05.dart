int partOne(String input) {
  RegExp vowels = RegExp(r'a|e|i|o|u');
  RegExp repeat = RegExp(r'(.)\1');
  RegExp badStrings = RegExp(r'ab|cd|pq|xy');

  var lines = input.split('\n');

  int good = lines.where((line) {
    var countVowels = vowels.allMatches(line).length;
    var hasRepeat = repeat.hasMatch(line);
    var containsForbidden = badStrings.hasMatch(line);

    return (countVowels >= 3 && hasRepeat && !containsForbidden);
  }).length;

  return good;
}

int partTwo(String input) {
  RegExp repeatPair = RegExp(r'(..).*\1');
  RegExp repeatSkip = RegExp(r'(.).\1');

  var lines = input.split('\n');

  int good = lines
      .where((line) => repeatPair.hasMatch(line) && repeatSkip.hasMatch(line))
      .length;

  return good;
}
