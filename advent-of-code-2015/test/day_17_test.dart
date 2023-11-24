import 'dart:io';
import 'package:test/test.dart';
import 'package:advent_2015/day_17.dart';

void main() {
  List<int> testInput = [20, 15, 10, 5, 5];
  List<int> realInput = [
    11,
    30,
    47,
    31,
    32,
    36,
    3,
    1,
    5,
    3,
    32,
    36,
    15,
    11,
    46,
    26,
    28,
    1,
    19,
    3,
  ];

  test('Part 1', () {
    expect(partOne(testInput, 25), 4);
    print(partOne(realInput, 150));
  });

  test('Part 2', () {
    print(partTwo(realInput, 150).length);
  });
}
