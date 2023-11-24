import 'dart:io';
import 'dart:math';

int partOne(String input) {
  int total = 0;
  RegExp exp = RegExp(r'(\d+)x(\d+)x(\d+)');
  Iterable<RegExpMatch> matches = exp.allMatches(input);

  for (final match in matches) {
    var l = int.parse(match.group(1)!);
    var w = int.parse(match.group(2)!);
    var h = int.parse(match.group(3)!);

    var sideOne = l * w;
    var sideTwo = h * w;
    var sideThree = h * l;

    total += 2 * (sideOne + sideTwo + sideThree) +
        min(sideOne, min(sideTwo, sideThree));
  }

  return total;
}

int partTwo(String input) {
  int total = 0;
  RegExp exp = RegExp(r'(\d+)x(\d+)x(\d+)');
  Iterable<RegExpMatch> matches = exp.allMatches(input);

  for (final match in matches) {
    var l = int.parse(match.group(1)!);
    var w = int.parse(match.group(2)!);
    var h = int.parse(match.group(3)!);

    var sideOne = 2 * l + 2 * w;
    var sideTwo = 2 * h + 2 * w;
    var sideThree = 2 * h + 2 * l;

    var ribbon = min(sideOne, min(sideTwo, sideThree));
    var bow = l * w * h;

    total += ribbon + bow;
  }

  return total;
}

void main() {
  String testInput = File("test-input").readAsStringSync();
  String realInput = File("input").readAsStringSync();

  var partOneExample = partOne(testInput);

  assert(partOneExample == 58);
  print(partOne(realInput));

  var partTwoExample = partTwo(testInput);
  assert(partTwoExample == 34);
  print(partTwo(realInput));
}
