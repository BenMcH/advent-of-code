import 'dart:io';
import 'package:test/test.dart';
import 'package:advent_2015/day_09.dart';

void main() {
  String testInput = File("resources/test-input-9").readAsStringSync();
  String realInput = File("resources/input-9").readAsStringSync();

  test('Part 1', () {
    expect(partOne(testInput), 605);
    print(partOne(realInput));
  });

  test('Part 2', () {
    expect(partTwo(testInput), 982);
    print(partTwo(realInput));
  });
}
