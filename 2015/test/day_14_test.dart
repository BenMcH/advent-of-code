import 'dart:io';
import 'package:test/test.dart';
import 'package:advent_2015/day_14.dart';

void main() {
  String testInput = File("resources/test-input-14").readAsStringSync();
  String realInput = File("resources/input-14").readAsStringSync();

  test('Part 1', () {
    expect(partOne(testInput, secondsToRun: 1000), 1120);
    print(partOne(realInput, secondsToRun: 2503));
  });

  test('Part 2', () {
    expect(partTwo(testInput, secondsToRun: 1000), 689);
    print(partTwo(realInput, secondsToRun: 2503));
  });
}
