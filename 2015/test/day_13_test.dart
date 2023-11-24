import 'dart:io';
import 'package:test/test.dart';
import 'package:advent_2015/day_13.dart';

void main() {
  String testInput = File("resources/test-input-13").readAsStringSync();
  String realInput = File("resources/input-13").readAsStringSync();

  test('Part 1', () {
    expect(partOne(testInput), 330);
    print(partOne(realInput));
  });

  test('Part 2', () {
    print(partTwo(realInput));
  });
}
