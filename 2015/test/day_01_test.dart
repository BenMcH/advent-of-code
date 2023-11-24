import 'dart:io';
import 'package:test/test.dart';
import 'package:advent_2015/day_01.dart';

void main() {
  String testInput = File("resources/test-input-1").readAsStringSync();
  String realInput = File("resources/input-1").readAsStringSync();

  test('Part 1', () {
    expect(floor(testInput), 3);
    print(floor(realInput));
  });

  test('Part 2', () {
    expect(findBasement(testInput), 1);
    print(findBasement(realInput));
  });
}
