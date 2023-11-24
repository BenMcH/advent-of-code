import 'dart:io';

import 'package:test/test.dart';
import 'package:advent_2015/day_24.dart';

void main() {
  List<int> testInput = File('./resources/test-input-24')
      .readAsLinesSync()
      .toList()
      .map((e) => int.parse(e))
      .toList();
  List<int> realInput = File('./resources/input-24')
      .readAsLinesSync()
      .toList()
      .map((e) => int.parse(e))
      .toList();

  test('Part 1', () {
    expect(partOne(testInput), 90);

    print(partOne(realInput));
  });

  // test('Part 2', () {
  //   var realComputer = Computer(realInput);
  //   realComputer.registers['a'] = 1;
  //   realComputer.runTilEnd();
  //   print(realComputer.registers['b']);
  // });
}
