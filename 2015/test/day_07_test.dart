import 'dart:io';
import 'package:test/test.dart';
import 'package:advent_2015/day_07.dart';

void main() {
  String testInput = File("resources/test-input-7").readAsStringSync();
  String realInput = File("resources/input-7").readAsStringSync();

  test('Part 1', () {
    expect(partOne(testInput), {
      'x': 123,
      'y': 456,
      'd': 72,
      'e': 507,
      'f': 492,
      'g': 114,
      'h': 65412,
      'i': 65079
    });
    var partOneAns = partOne(realInput);
    print(partOneAns['a']);
    realInput = realInput.replaceFirst('14146 -> b', '${partOneAns['a']} -> b');
    print(partOne(realInput)['a']);
  });
}
