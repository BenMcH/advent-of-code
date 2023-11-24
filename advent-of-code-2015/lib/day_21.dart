import 'dart:math';

import 'package:trotter/trotter.dart';

class Equipment {
  final String name;
  final int cost;
  final int damage;
  final int armor;

  const Equipment(this.name, this.cost, this.damage, this.armor);
}

class Stats {
  late int hitPoints;
  late int damage;
  late int armor;
  late int gold;
  int spent = 0;

  Stats(this.hitPoints, this.damage, this.armor, {this.gold = 0});

  Stats.from(Stats stats) {
    hitPoints = stats.hitPoints;
    damage = stats.damage;
    armor = stats.armor;
    gold = stats.gold;
  }

  bool attack(Stats other) {
    var attackDamage = damage - other.armor;

    other.hitPoints -= attackDamage;

    return other.hitPoints <= 0;
  }

  void useEquipment(Equipment equipment) {
    if (gold - spent > equipment.cost) return;

    spent += equipment.cost;
    damage += equipment.damage;
    armor += equipment.armor;
  }
}

const emptyEquipment = Equipment('Nothing', 0, 0, 0);

var weapons = const [
  Equipment('Dagger', 8, 4, 0),
  Equipment('Shortsword', 10, 5, 0),
  Equipment('Warhammer', 25, 6, 0),
  Equipment('Longsword', 40, 7, 0),
  Equipment('Greataxe', 74, 8, 0),
];

var armor = const [
  Equipment('Nothing', 0, 0, 0),
  Equipment('Leather', 13, 0, 1),
  Equipment('Chainmail', 31, 0, 2),
  Equipment('Splintmail', 53, 0, 3),
  Equipment('Bandedmail', 75, 0, 4),
  Equipment('Platemail', 102, 0, 5),
];

var rings = const [
  Equipment('Nothing1', 0, 0, 0),
  Equipment('Nothing2', 0, 0, 0),
  Equipment('DefenseOne', 20, 0, 1),
  Equipment('DamageOne', 25, 1, 0),
  Equipment('DefenseTwo', 40, 0, 2),
  Equipment('DamageTwo', 50, 2, 0),
  Equipment('DefenseThree', 80, 0, 3),
  Equipment('DamageThree', 100, 3, 0),
];

bool canBeatBoss(Stats player, Stats boss) {
  bool playerTurn = true;

  var win = false;
  do {
    if (playerTurn) {
      win = player.attack(boss);
    } else {
      win = boss.attack(player);
    }

    playerTurn = !playerTurn;
  } while (!win);

  return !playerTurn;
}

int partOne(Stats player, Stats boss) {
  int least = 999;

  for (var weapon in weapons) {
    for (var armorType in armor) {
      var combos = Combinations(2, rings);

      for (var r in combos()) {
        var innerPlayer = Stats.from(player);
        var innerBoss = Stats.from(boss);

        innerPlayer.useEquipment(weapon);
        innerPlayer.useEquipment(armorType);
        innerPlayer.useEquipment(r.first);
        innerPlayer.useEquipment(r.last);

        if (innerPlayer.spent >= least) continue;

        if (canBeatBoss(innerPlayer, innerBoss)) {
          least = innerPlayer.spent;
        }
      }
    }
  }

  return least;
}

int partTwo(Stats player, Stats boss) {
  int most = 0;

  for (var weapon in weapons) {
    for (var armorType in armor) {
      var combos = Combinations(2, rings);

      for (var r in combos()) {
        var innerPlayer = Stats.from(player);
        var innerBoss = Stats.from(boss);

        innerPlayer.useEquipment(weapon);
        innerPlayer.useEquipment(armorType);
        innerPlayer.useEquipment(r.first);
        innerPlayer.useEquipment(r.last);

        if (innerPlayer.spent <= most) continue;

        if (!canBeatBoss(innerPlayer, innerBoss)) {
          most = innerPlayer.spent;
        }
      }
    }
  }

  return most;
}
