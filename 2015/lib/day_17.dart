import 'dart:math';

int partOne(List<int> input, int target) {
  int count = 0;

  if (input.isEmpty && target > 0 || target < 0) return 0;
  if (target == 0) return 1;

  while (input.isNotEmpty) {
    var a = target - input[0];
    input = input.sublist(1);
    count += partOne(input, a);
  }

  return count;
}

Iterable<List<int>> partTwo(List<int> input, int target,
    {List<int> group = const []}) {
  List<List<int>> vals = [];

  if (input.isEmpty && target > 0 || target < 0) return [];
  if (target == 0) return [group];

  while (input.isNotEmpty) {
    List<int> newList = List.from(group);
    var a = target - input[0];
    newList.add(input[0]);
    input = input.sublist(1);
    vals.addAll(partTwo(input, a, group: newList));
  }

  int minLength = vals.isEmpty ? 0 : vals.map((e) => e.length).reduce(min);

  return vals.where((element) => element.length == minLength);
}
