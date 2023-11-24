import 'dart:math';

typedef Board = List<List<bool>>;

Board step(Board board) {
  Board newBoard = [];

  for (var i = 0; i < board.length; i++) {
    List<bool> row = List.from(board[i]);

    for (var j = 0; j < row.length; j++) {
      var neighbors = 0;

      if (i > 0) {
        if (j > 0 && board[i - 1][j - 1]) neighbors += 1;
        if (board[i - 1][j]) neighbors += 1;
        if (j < row.length - 1 && board[i - 1][j + 1]) neighbors += 1;
      }

      if (j > 0 && board[i][j - 1]) neighbors += 1;
      if (j < row.length - 1 && board[i][j + 1]) neighbors += 1;

      if (i < board.length - 1) {
        if (j > 0 && board[i + 1][j - 1]) neighbors += 1;
        if (board[i + 1][j]) neighbors += 1;
        if (j < row.length - 1 && board[i + 1][j + 1]) neighbors += 1;
      }

      if (row[j]) {
        row[j] = [2, 3].contains(neighbors);
      } else {
        row[j] = 3 == neighbors;
      }
    }
    newBoard.add(row);
  }

  return newBoard;
}

int partOne(String input, int rounds, {bool partTwo = false}) {
  var lines = input.split('\n');

  Board board = [];

  for (var line in lines) {
    if (line.isEmpty) continue;
    var row = line.split('').map((e) => e == '#').toList();
    board.add(row);
  }

  var top = 0;
  var left = 0;
  var bottom = board.length - 1;
  var right = board[0].length - 1;

  if (partTwo) {
    board[top][left] = true;
    board[top][right] = true;
    board[bottom][left] = true;
    board[bottom][right] = true;
  }

  print("Board: ${board.length} Row: ${board[0].length}");

  for (var i = 0; i < rounds; i++) {
    board = step(board);

    if (partTwo) {
      board[top][left] = true;
      board[top][right] = true;
      board[bottom][left] = true;
      board[bottom][right] = true;
    }
  }

  return board
      .map((e) =>
          e.map((e) => e ? 1 : 0).reduce((value, element) => value + element))
      .reduce((value, element) => value + element);
}

// Iterable<List<int>> partTwo(List<int> input, int target,
//     {List<int> group = const []}) {
//   List<List<int>> vals = [];

//   if (input.isEmpty && target > 0 || target < 0) return [];
//   if (target == 0) return [group];

//   while (input.isNotEmpty) {
//     List<int> newList = List.from(group);
//     var a = target - input[0];
//     newList.add(input[0]);
//     input = input.sublist(1);
//     vals.addAll(partTwo(input, a, group: newList));
//   }

//   int minLength = vals.isEmpty ? 0 : vals.map((e) => e.length).reduce(min);

//   return vals.where((element) => element.length == minLength);
// }
