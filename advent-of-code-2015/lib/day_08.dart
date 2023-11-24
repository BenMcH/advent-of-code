partOne(String input) {
  var lines = input.split("\n").where((element) => element.isNotEmpty);

  var total = 0;
  var totalMinusOuterQuotes = 0;

  for (var line in lines) {
    total += line.length;

    line = line.substring(1, line.length - 1);
    line = line.replaceAll(r'\\', r'^');
    line = line.replaceAll(r'\"', r'"');
    line = line.replaceAll(RegExp(r'\\x[0-9a-fA-F]{2}'), r'!');

    totalMinusOuterQuotes += line.length;
  }

  return total - totalMinusOuterQuotes;
}

partTwo(String input) {
  var lines = input.split("\n").where((element) => element.isNotEmpty);

  var total = 0;
  var totalEncoded = 0;

  for (var line in lines) {
    total += line.length;

    line = line.replaceAll(r'\', r'\\');
    line = line.replaceAll(r'"', r'\"');

    line = '"$line"';

    totalEncoded += line.length;
  }

  return totalEncoded - total;
}
