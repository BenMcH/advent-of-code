import 'dart:convert';

int partOne(String input) {
  var numbersRegex = RegExp(r'(-?\d+)');

  var total = 0;

  for (var n in numbersRegex.allMatches(input)) {
    total += int.parse(n[0]!);
  }

  return total;
}

int countNumbers(dynamic obj) {
  if (obj is int) {
    return obj;
  }

  if (obj is List) {
    var totalArr = obj.map((e) => countNumbers(e));

    return totalArr.reduce((value, element) => value + element);
  }

  if (obj is Map) {
    if (obj.containsValue("red")) {
      return 0;
    }

    var totalArr = obj.values.map((e) => countNumbers(e));

    return totalArr.reduce((value, element) => value + element);
  }

  if (obj is String) {
    return 0;
  }

  throw "Unknown type: ${obj.runtimeType}";
}

int partTwo(String input) {
  var obj = jsonDecode(input);
  return countNumbers(obj);
}
