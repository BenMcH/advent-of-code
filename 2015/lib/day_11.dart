import 'dart:math' as math;

final aCodeUnit = "a".codeUnitAt(0);
final zCodeUnit = "z".codeUnitAt(0);

String increment(String password) {
  var characters = password.split("");
  var lastCodeUnit = characters.last.codeUnitAt(0);

  if (lastCodeUnit == zCodeUnit) {
    characters = password.length > 1
        ? increment(password.substring(0, password.length - 1)).split("")
        : ['a'];
    characters.add('a');
  } else {
    characters.last = String.fromCharCode(lastCodeUnit + 1);
  }

  return characters.join();
}

bool isValidPassword(String password) {
  if (['i', 'o', 'l'].any((element) => password.contains(element))) {
    return false;
  }

  var pairPattern = RegExp(r'([a-z])\1');
  var pairs = pairPattern.allMatches(password);
  var starts = pairs.map((e) => e.start);

  if (pairs.length < 2 ||
      starts.reduce(math.max) - 2 <= starts.reduce(math.min)) {
    return false;
  }

  for (var i = 0; i < password.length - 3; i++) {
    if (password.codeUnitAt(i) + 1 == password.codeUnitAt(i + 1) &&
        password.codeUnitAt(i + 1) + 1 == password.codeUnitAt(i + 2)) {
      return true;
    }
  }

  return false;
}

String partOne(String input) {
  var nextPassword = increment(input);

  while (!isValidPassword(nextPassword)) {
    nextPassword = increment(nextPassword);
  }

  return nextPassword;
}
