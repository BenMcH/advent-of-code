import 'dart:math';

String partOne(String input) {
  var ans = StringBuffer();
  var char = input[0];
  var count = 0;

  for (var x = 0; x < input.length; x++) {
    if (char == input[x]) {
      count += 1;
    } else {
      ans.write("$count$char");
      count = 1;
      char = input[x];
    }
  }

  ans.write("$count$char");

  return ans.toString();
}

partTwo(String input) {}
