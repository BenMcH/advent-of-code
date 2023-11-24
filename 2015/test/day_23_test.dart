import 'dart:io';

import 'package:test/test.dart';
import 'package:advent_2015/day_23.dart';

void main() {
  var testInput = File('./resources/test-input-23')
      .readAsLinesSync()
      .map((e) => Instruction.parse(e.replaceAll(',', '')))
      .toList();
  var realInput = File('./resources/input-23')
      .readAsLinesSync()
      .map((e) => Instruction.parse(e.replaceAll(',', '')))
      .toList();

  test('Part 1', () {
    var testComputer = Computer(testInput);

    testComputer.runTilEnd();
    expect(testComputer.registers['a'], 2);

    var realComputer = Computer(realInput);
    realComputer.runTilEnd();
    print(realComputer.registers['b']);
  });

  test('Part 2', () {
    var realComputer = Computer(realInput);
    realComputer.registers['a'] = 1;
    realComputer.runTilEnd();
    print(realComputer.registers['b']);
  });
}
