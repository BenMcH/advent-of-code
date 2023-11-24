import 'dart:math';

List<int> factors(int num) {
  List<int> factors = [];

  var sqrt_num = sqrt(num);
  var i = 1;
  while (i < sqrt_num) {
    if (num % i == 0) {
      factors.add(i);
      factors.add(num ~/ i);
    }
    i++;
  }

  return factors;
}

int scoreHouse(int houseNumber,
    {bool partTwo = false, int giftsDeliveredPerElf = 10}) {
  var f = factors(houseNumber);
  var total = 0;

  for (var e in f) {
    if (!partTwo || e * 50 >= houseNumber) {
      total += e * giftsDeliveredPerElf;
    }
  }

  return total;
}

int partOne(int target) {
  int i = 1;

  while (scoreHouse(i) < target) {
    i++;
  }

  return i;
}

int partTwo(int target) {
  int i = 1;

  while (scoreHouse(i, partTwo: true, giftsDeliveredPerElf: 11) < target) {
    i++;
  }

  return i;
}
