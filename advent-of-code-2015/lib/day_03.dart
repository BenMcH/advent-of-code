class Point {
  int x;
  int y;

  Point(this.x, this.y);

  int get hashCode => Object.hash(x, y);

  bool operator ==(o) => o is Point && o.x == x && o.y == y;

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

  String toString() {
    return "($x,$y)";
  }
}

int partOne(String input) {
  Set<Point> houses = {};

  Point currentPoint = Point(0, 0);

  houses.add(currentPoint);
  for (final direction in input.split("")) {
    currentPoint = currentPoint.inDirection(direction);
    houses.add(currentPoint);
  }

  return houses.length;
}

int partTwo(String input) {
  Set<Point> houses = {};

  Point santasPoint = Point(0, 0);
  Point roboSantasPoint = Point(0, 0);

  houses.add(santasPoint);
  var santa = true;
  for (final direction in input.split("")) {
    if (santa) {
      santasPoint = santasPoint.inDirection(direction);
      houses.add(santasPoint);
    } else {
      roboSantasPoint = roboSantasPoint.inDirection(direction);
      houses.add(roboSantasPoint);
    }

    santa = !santa;
  }

  return houses.length;
}
