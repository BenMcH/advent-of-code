import 'package:test/test.dart';
import 'package:advent_2015/day_10.dart';

void main() {
  String testInput = "111221";
  String realInput = "3113322113";

  test('Part 1', () {
    expect(partOne(testInput), "312211");

    String answer = realInput;

    for (var x = 0; x < 40; x++) {
      answer = partOne(answer);
    }
    print(answer.length);
  });

  test('Part 2', () {
    expect(partOne(testInput), "312211");

    String answer = realInput;

    for (var x = 0; x < 50; x++) {
      answer = partOne(answer);
    }
    print(answer.length);
  });
}
