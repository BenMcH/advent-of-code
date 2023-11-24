import 'dart:io';

typedef GiftSack = Set<int>;

List<GiftSack> findTargets(List<int> inputs, int target) {
  if (inputs.isEmpty) {
    return [];
  }

  List<GiftSack> targets = [];

  for (var input in inputs) {
    if (input > target) {
      continue;
    }

    if (input == target) {
      targets.add({input});
    } else {
      var results =
          findTargets(inputs.sublist(inputs.indexOf(input)), target - input)
              .map((e) {
        e.add(input);

        return e;
      });

      targets.addAll(results);
    }
  }

  return targets;
}

bool overlaps(GiftSack a, GiftSack b) {
  return a.any((element) => b.contains(element));
}

Iterable<List<GiftSack>> findCandidateGroups(Iterable<GiftSack> inputs,
    {int targetSize = 4}) {
  List<List<GiftSack>> groups = [];

  if (targetSize == 1) {
    return inputs.map((e) => [e]);
  }

  for (var i = 0; i < inputs.length; i++) {
    var input = inputs.elementAt(i);
    var possibles = inputs.skip(i + 1).where((sack) => !overlaps(input, sack));

    if (targetSize == 1 && possibles.isNotEmpty) {
      print("HERE");
    }

    // if (targetSize == 3) {
    //   print(possibles.length);
    // }

    var actuals = findCandidateGroups(possibles, targetSize: targetSize - 1);

    for (var act in actuals) {
      act.add(input);
    }

    groups.addAll(actuals);
  }

  return groups;
}

int partOne(List<int> input) {
  int total = input.reduce((value, element) => value + element);
  int target = total ~/ 3;
  List<GiftSack> opts = findTargets(input, target);

  var groups = findCandidateGroups(opts).toSet();

  // File('output').writeAsStringSync(groups.toString());
  print(groups.length);

  return 0;
}
