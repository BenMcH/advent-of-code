import 'package:test/test.dart';
import 'package:advent_2015/day_21.dart';

void main() {
  Stats player = Stats(100, 0, 0);
  Stats boss = Stats(103, 9, 2);

  test('Part 1', () {
    print(partOne(player, boss));
  });

  test('Part 2', () {
    print(partTwo(player, boss));
  });
}
