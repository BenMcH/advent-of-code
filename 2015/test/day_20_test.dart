import 'package:test/test.dart';
import 'package:advent_2015/day_20.dart';

void main() {
  int testInput = 100;
  int realInput = 33100000;

  test('Part 1', () {
    expect(partOne(testInput), 6);
    print(partOne(realInput));
  });

  test('Part 2', () {
    expect(partTwo(testInput), 6);
    print(partTwo(realInput));
  });
}
