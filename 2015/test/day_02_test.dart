import 'dart:io';
import 'package:test/test.dart';
import 'package:advent_2015/day_02.dart';

void main() {
  String testInput = File("resources/test-input-2").readAsStringSync();
  String realInput = File("resources/input-2").readAsStringSync();

  test('Part 1', () {
    expect(partOne(testInput), 58);
    print(partOne(realInput));
  });

  test('Part 2', () {
    expect(partTwo(testInput), 34);
    print(partTwo(realInput));
  });
}
