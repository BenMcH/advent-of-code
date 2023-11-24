onst input = await Deno.readTextFile('./input.txt');

let [draws, ...allBoards] = input.split('\n\n')

type Board = string[][];

let boards: Board[] = allBoards.map((board: string) => board.split('\n').map((row) => row.split(/\s+/).filter((cell) => cell !== '')));
const originalBoards = boards;

const DRAWN = 'X';

const boardWins = (board: Board): boolean => {
	return (
		board.some((row) => row.every((cell) => cell === DRAWN)) // Row
		||
		Array.from({length: board[0].length}).some((_, i) => board.every((row) => row[i] === DRAWN)) // Column
	);
}

const playRound = (boards: Board[], call: string): Board[] => (
	boards.map((
		board) => board.map(
			(row) => row.map((cell) => cell === call ? DRAWN : cell)
		)
	)
)

const sumBoard = (board: Board): number => board.reduce((sum, row) => sum + row.reduce((sum, cell) => sum + (cell === DRAWN ? 0 : Number.parseInt(cell)), 0), 0);

const calls = draws.split(',')

let winningBoard: Board | undefined;
let call: undefined | string;

for (call of calls) {
	boards = playRound(boards, call)

	winningBoard = boards.find(boardWins);

	if (winningBoard) {
		break;
	}
}

if (!winningBoard || !call) {
	throw new Error('woah')
}

let total = sumBoard(winningBoard);
let callNum = Number.parseInt(call);

console.log(total * callNum);

// Part 2

boards = originalBoards;

for (call of calls) {
	boards = boards.map((
		board) => board.map(
			(row) => row.map((cell) => cell === call ? DRAWN : cell)
		)
	);	

	if (boards.length > 1) {
		boards = boards.filter((board) => !boardWins(board));
	}


	winningBoard = boards.find(boardWins);

	if (winningBoard) {
		break;
	}
}

if (!winningBoard || !call) {
	throw new Error('woah')
}

total = sumBoard(winningBoard);
callNum = Number.parseInt(call);

console.log(total * callNum);
