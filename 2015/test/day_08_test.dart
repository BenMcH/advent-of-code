import 'dart:io';
import 'package:test/test.dart';
import 'package:advent_2015/day_08.dart';

void main() {
  String testInput = File("resources/test-input-8").readAsStringSync();
  String realInput = File("resources/input-8").readAsStringSync();

  test('Part 1', () {
    expect(partOne(testInput), 12);
    print(partOne(realInput));
  });

  test('Part 2', () {
    expect(partTwo(testInput), 19);
    print(partTwo(realInput));
  });
}
