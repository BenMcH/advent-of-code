import 'dart:io';
import 'package:test/test.dart';
import 'package:advent_2015/day_18.dart';

void main() {
  String testInput = File("resources/test-input-18").readAsStringSync();
  String realInput = File("resources/input-18").readAsStringSync();

  test('Part 1', () {
    expect(partOne(testInput, 4), 4);
    print(partOne(realInput, 100));
  });

  test('Part 2', () {
    testInput = "##.#.#\n...##.\n#....#\n..#...\n#.#..#\n####.#";
    expect(partOne(testInput, 5, partTwo: true), 17);
    print(partOne(realInput, 100, partTwo: true));
  });
}
