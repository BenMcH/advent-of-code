enum Attribute { hp, damage, armor, mana, spent }

class Effect {
  Attribute attribute;
  int amount;
  int turns;

  Effect(this.attribute, this.amount, this.turns);
}

class Tuple<T1, T2> {
  T1 t1;
  T2 t2;

  Tuple(this.t1, this.t2);
}

typedef Battle = Tuple<Stats, Stats>;

class Stats {
  Map<Attribute, int> attributes = {};
  List<Effect> effects = [];
  int spent = 0;

  Stats(int hitPoints, int damage, {int mana = 0, int armor = 0}) {
    attributes[Attribute.hp] = hitPoints;
    attributes[Attribute.damage] = damage;
    attributes[Attribute.mana] = mana;
    attributes[Attribute.armor] = armor;
    attributes[Attribute.spent] = 0;
  }

  Stats.from(Stats stats) {
    attributes = Map.from(stats.attributes);
    spent = stats.spent;
  }

  Stats applyEffects() {
    Stats effectiveStats = Stats.from(this);
    effectiveStats.effects = [];

    for (var effect in effects) {
      int currentAmount = effectiveStats.attributes[effect.attribute] ?? 0;

      effectiveStats.attributes[effect.attribute] =
          currentAmount + effect.amount;
    }

    effects.removeWhere((element) => element.turns == 0);

    return effectiveStats;
  }

  List<Battle> attack(Stats stats) {
    List<Battle> nextBattles = [];

    var effectiveStats = applyEffects();
    var effectiveOpponent = stats.applyEffects();

    var starterOpponent = Stats.from(stats);
    var starterSelf = Stats.from(this);

    return nextBattles;
  }
}

bool canBeatBoss(Stats player, Stats boss) {
  bool playerTurn = true;

  var win = false;
  do {
    if (playerTurn) {
      // win = player.attack(boss);
    } else {
      // win = boss.attack(player);
    }

    playerTurn = !playerTurn;
  } while (!win);

  return !playerTurn;
}

int partOne(Stats player, Stats boss) {
  int least = 999;

  // for (var weapon in weapons) {
  //   for (var armorType in armor) {
  //     var combos = Combinations(2, rings);

  //     for (var r in combos()) {
  //       var innerPlayer = Stats.from(player);
  //       var innerBoss = Stats.from(boss);

  //       innerPlayer.useEquipment(weapon);
  //       innerPlayer.useEquipment(armorType);
  //       innerPlayer.useEquipment(r.first);
  //       innerPlayer.useEquipment(r.last);

  //       if (innerPlayer.spent >= least) continue;

  //       if (canBeatBoss(innerPlayer, innerBoss)) {
  //         least = innerPlayer.spent;
  //       }
  //     }
  //   }
  // }

  return least;
}
