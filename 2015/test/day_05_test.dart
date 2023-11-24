import 'dart:io';
import 'package:test/test.dart';
import 'package:advent_2015/day_05.dart';

void main() {
  String testInput = File("resources/test-input-5").readAsStringSync();
  String realInput = File("resources/input-5").readAsStringSync();

  test('Part 1', () {
    expect(partOne(testInput), 2);
    print(partOne(realInput));
  });

  test('Part 2', () {
    var string = "qjhvhtzxzqqjkmpb\nxxyxx\nieodomkazucvgmuy\nieodomkazucvgmuy";
    expect(partTwo(string), 2);
    print(partTwo(realInput));
  });
}
