import 'dart:io';
import 'package:test/test.dart';
import 'package:advent_2015/day_15.dart';

void main() {
  String testInput = File("resources/test-input-15").readAsStringSync();
  String realInput = File("resources/input-15").readAsStringSync();

  test('Part 1', () {
    expect(partOne(testInput), 62842880);
    print(partOne(realInput));
  });

  test('Part 2', () {
    expect(partOne(testInput, partTwo: true, goalCalories: 500), 57600000);
    print(partOne(realInput, partTwo: true, goalCalories: 500));
  });
}
