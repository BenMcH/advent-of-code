import 'package:test/test.dart';
import 'package:advent_2015/day_04.dart';

void main() {
  String testInput = "abcdef";
  String realInput = "yzbqklnj";

  test('Part 1', () {
    expect(partOne(testInput), 609043);
    print(partOne(realInput));
  });

  test('Part 2', () {
    print(partOne(realInput, length: 6));
  });
}
