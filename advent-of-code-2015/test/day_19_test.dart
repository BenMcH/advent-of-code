import 'dart:io';
import 'package:test/test.dart';
import 'package:advent_2015/day_19.dart';

void main() {
  String testInput = File("resources/test-input-19").readAsStringSync();
  String realInput = File("resources/input-19").readAsStringSync();

  test('Part 1', () {
    expect(partOne(testInput), 4);
    print(partOne(realInput));
  });

  test('Part 2', () {
    testInput = 'e => H\ne => O\nH => HO\nH => OH\nO => HH\n\nHOH';
    expect(partTwo(testInput), 3);
    print(partTwo(realInput));
  });
}
