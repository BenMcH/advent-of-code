import 'dart:io';
import 'package:test/test.dart';
import 'package:advent_2015/day_03.dart';

void main() {
  String testInput = File("resources/test-input-3").readAsStringSync();
  String realInput = File("resources/input-3").readAsStringSync();

  test('Part 1', () {
    expect(partOne(testInput), 2);
    print(partOne(realInput));
  });

  test('Part 2', () {
    expect(partTwo(testInput), 11);
    print(partTwo(realInput));
  });
}
