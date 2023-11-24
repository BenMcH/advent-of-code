import 'dart:math';

import 'package:trotter/trotter.dart';

enum MODE { fly, rest }

class Reindeer {
  String name;
  int speed;
  int flyTime;
  int restTime;
  int dist = 0;
  late int timer;
  late MODE mode;

  Reindeer(this.name, this.speed, this.flyTime, this.restTime) {
    mode = MODE.fly;
    timer = flyTime;
  }

  void step() {
    timer -= 1;

    if (mode == MODE.fly) {
      dist += speed;

      if (timer == 0) {
        timer = restTime;
        mode = MODE.rest;
      }
    } else {
      if (timer == 0) {
        timer = flyTime;
        mode = MODE.fly;
      }
    }
  }

  int distanceAfterSeconds(int secondsLeft) {
    while (secondsLeft > 0) {
      var localFlyTime = min(secondsLeft, flyTime);
      dist += localFlyTime * speed;
      secondsLeft -= localFlyTime;

      var localRestTime = min(secondsLeft, restTime);
      secondsLeft -= localRestTime;
    }

    return dist;
  }

  String toString() {
    return "$name $speed for $flyTime then rest for $restTime";
  }
}

List<Reindeer> parseInput(String input) {
  var lines = input.split('\n');

  List<Reindeer> lookup = [];

  var reg = RegExp(
      r'(\w+) can fly (\d+) km/s for (\d+) seconds, but then must rest for (\d+) seconds.');

  for (var element in lines) {
    var match = reg.firstMatch(element);

    if (match == null) {
      continue;
    }

    var name = match.group(1)!;
    var speed = int.parse(match.group(2)!);
    var time1 = int.parse(match.group(3)!);
    var time2 = int.parse(match.group(4)!);

    lookup.add(Reindeer(name, speed, time1, time2));
  }

  return lookup;
}

partOne(String input, {int secondsToRun = 1000}) {
  var lookup = parseInput(input);

  while (secondsToRun >= 0) {
    for (var reindeer in lookup) {
      reindeer.step();
    }

    secondsToRun -= 1;
  }

  return lookup.map((e) => e.dist).reduce(max);
}

partTwo(String input, {int secondsToRun = 1000}) {
  var lookup = parseInput(input);

  Map<String, int> scores = {};

  var furthestDist = 0;
  while (secondsToRun >= 0) {
    for (var reindeer in lookup) {
      reindeer.step();

      if (reindeer.dist > furthestDist) furthestDist = reindeer.dist;
    }

    for (var rd in lookup) {
      if (rd.dist == furthestDist) {
        scores[rd.name] ??= 0;
        scores[rd.name] = scores[rd.name]! + 1;
      }
    }

    secondsToRun -= 1;
  }

  return scores.values.reduce(max);
}
