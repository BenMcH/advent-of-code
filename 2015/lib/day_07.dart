partOne(String input) {
  var lines = input.split('\n');

  var infixOperations = RegExp(r'(.+)\s(AND|RSHIFT|OR|LSHIFT)\s(.+)\s->\s(.+)');
  var prefixOperations = RegExp(r'NOT\s(.+)\s->\s(.+)');
  var basicValue = RegExp(r'(.+) -> (.+)');
  var isAlpha = RegExp(r'[a-z]+');

  Map<String, int> registers = {};

  while (lines.isNotEmpty) {
    var command = lines.removeAt(0);

    if (infixOperations.firstMatch(command) != null) {
      var match = infixOperations.firstMatch(command);

      var opOne = match![1];
      var opTwo = match[3];

      int? valOne =
          isAlpha.hasMatch(opOne!) ? registers[opOne] : int.parse(opOne);
      int? valTwo =
          isAlpha.hasMatch(opTwo!) ? registers[opTwo] : int.parse(opTwo);

      if (valOne == null || valTwo == null) {
        lines.add(command);
        continue;
      }

      int finalVal = 0;

      switch (match[2]) {
        case 'AND':
          finalVal = valOne & valTwo;
          break;
        case 'OR':
          finalVal = valOne | valTwo;
          break;
        case 'RSHIFT':
          finalVal = valOne >> valTwo;
          break;
        case 'LSHIFT':
          finalVal = valOne << valTwo;
          break;
        default:
          print("Unknown match");
      }

      registers[match[4]!] = finalVal % 65536;
    } else if (prefixOperations.firstMatch(command) != null) {
      var match = prefixOperations.firstMatch(command);
      var notVal = match![1];

      if (!registers.containsKey(notVal)) {
        lines.add(command);
        continue;
      }

      var newVal = ~registers[notVal]!;

      var newRegisterIndex = match[2];

      registers[newRegisterIndex!] = newVal % 65536;
    } else if (basicValue.firstMatch(command) != null) {
      var match = basicValue.firstMatch(command);

      var register = match![2];
      var strVal = match[1];

      if (isAlpha.hasMatch(strVal!)) {
        if (!registers.containsKey(strVal)) {
          lines.add(command);
        } else {
          registers[register!] = registers[strVal]! % 65536;
        }
        continue;
      }

      registers[register!] = int.parse(match[1]!) % 65536;
    } else {
      print("UNKNOWN: $command");
    }
  }

  return registers;
}

int partTwo(String input) {
  return 0;
}
