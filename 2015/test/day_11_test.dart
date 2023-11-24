import 'package:test/test.dart';
import 'package:advent_2015/day_11.dart';

void main() {
  String testInput = "ghijklmn";
  String realInput = "hepxcrrq";

  test('increment', () {
    expect(increment('xx'), 'xy');
    expect(increment('xy'), 'xz');
    expect(increment('xz'), 'ya');
    expect(increment('ya'), 'yb');
  });

  test('Part 1', () {
    expect(partOne(testInput), "ghjaabcc");
    print(partOne(realInput));
  });

  test('Part 2', () {
    expect(partOne(testInput), "ghjaabcc");
    var expired = partOne(realInput);

    print(partOne(expired));
  });
}
