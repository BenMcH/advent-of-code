class Point {
  int x;
  int y;

  Point(this.x, this.y);

  @override
  int get hashCode => Object.hash(x, y);

  @override
  bool operator ==(other) => other is Point && other.x == x && other.y == y;

  Point inDirection(String direction) {
    switch (direction) {
      case '<':
        return Point(x - 1, y);
      case '>':
        return Point(x + 1, y);
      case '^':
        return Point(x, y - 1);
      case 'v':
        return Point(x, y + 1);
      default:
        return this;
    }
  }

  @override
  String toString() {
    return "($x,$y)";
  }
}

int partOne(String input) {
  var lines = input.split('\n');
  var instructionRegex = RegExp(r'(.*)\s(\d+),(\d+) through (\d+),(\d+)');

  Set<Point> onLights = {};

  for (var line in lines) {
    var instructionMatch = instructionRegex.firstMatch(line);

    if (instructionMatch == null) {
      continue;
    }

    var instruction = instructionMatch.group(1);
    var startX = instructionMatch.group(2);
    var startY = instructionMatch.group(3);
    var endX = instructionMatch.group(4);
    var endY = instructionMatch.group(5);

    for (int x = int.parse(startX!); x <= int.parse(endX!); x++) {
      for (int y = int.parse(startY!); y <= int.parse(endY!); y++) {
        Point point = Point(x, y);
        if (instruction == 'turn on') {
          onLights.add(point);
        } else if (instruction == 'turn off') {
          onLights.remove(point);
        } else {
          onLights.contains(point)
              ? onLights.remove(point)
              : onLights.add(point);
        }
      }
    }
  }

  return onLights.length;
}

int partTwo(String input) {
  var lines = input.split('\n');
  var instructionRegex = RegExp(r'(.*)\s(\d+),(\d+) through (\d+),(\d+)');

  Map<Point, int> onLights = {};

  for (var x = 0; x < 1000; x++) {
    for (var y = 0; y < 1000; y++) {
      var p = Point(x, y);
      onLights[p] = 0;
    }
  }

  for (var line in lines) {
    var instructionMatch = instructionRegex.firstMatch(line);

    if (instructionMatch == null) {
      continue;
    }

    var instruction = instructionMatch.group(1);
    var startX = instructionMatch.group(2);
    var startY = instructionMatch.group(3);
    var endX = instructionMatch.group(4);
    var endY = instructionMatch.group(5);

    for (int x = int.parse(startX!); x <= int.parse(endX!); x++) {
      for (int y = int.parse(startY!); y <= int.parse(endY!); y++) {
        Point point = Point(x, y);
        if (instruction == 'turn on') {
          onLights[point] = onLights[point]! + 1;
        } else if (instruction == 'turn off') {
          onLights[point] = onLights[point]! - 1;

          if (onLights[point]! < 0) {
            onLights[point] = 0;
          }
        } else {
          onLights[point] = onLights[point]! + 2;
        }
      }
    }
  }

  var total = 0;

  for (var x = 0; x < 1000; x++) {
    for (var y = 0; y < 1000; y++) {
      var p = Point(x, y);
      total += onLights[p]!;
    }
  }

  return total;
}
