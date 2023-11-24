int floor(String input) {
  int floor = 0;

  input.split("").forEach((String element) {
    if (element == ')') {
      floor -= 1;
    } else if (element == '(') {
      floor += 1;
    }
  });

  return floor;
}

int findBasement(String input) {
  var chars = input.split("");

  int level = 0;

  for (int i = 0; i < chars.length; i++) {
    var element = chars[i];

    if (element == ')') {
      level -= 1;
    } else if (element == '(') {
      level += 1;
    }

    if (level < 0) {
      return i + 1;
    }
  }

  throw Exception("Never enters basement");
}
