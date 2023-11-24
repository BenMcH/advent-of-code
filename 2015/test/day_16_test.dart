import 'dart:io';
import 'package:test/test.dart';
import 'package:advent_2015/day_16.dart';

void main() {
  String realInput = File("resources/input-16").readAsStringSync();

  test('Part 1', () {
    print(partOne(realInput));
  });

  test('Part 2', () {
    print(partTwo(realInput));
  });
}
