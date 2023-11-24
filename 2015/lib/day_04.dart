import 'package:crypto/crypto.dart' as crypto;
import 'dart:convert';

int partOne(String input, {int length = 5}) {
  int i = 0;

  var result = "";

  while (!result.startsWith("0" * length)) {
    i++;
    result = crypto.md5.convert(utf8.encode('$input$i')).toString();
  }

  return i;
}
