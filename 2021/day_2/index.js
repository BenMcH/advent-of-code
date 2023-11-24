const fs = require('fs');

const rows = fs.readFileSync('input.txt', 'utf8').split('\n').map((row) => {
	let newVal = row.split(' ')
	newVal[1] = parseInt(newVal[1])
	return newVal
});

let firstCalcPos = {horizontal: 0, vertical: 0}
let secondCalcPos = {horizontal: 0, vertical: 0, aim: 0}

rows.forEach(row => {
	let [instruction, amount] = row;

	if (['down', 'up'].includes(instruction)) {
		if (instruction === 'up') amount *= -1

		firstCalcPos.vertical += amount;
		secondCalcPos.aim += amount;
	} else if ('forward' === instruction) {
		firstCalcPos.horizontal += amount;
		secondCalcPos.horizontal += amount;
		secondCalcPos.vertical += (amount * secondCalcPos.aim);
	}
})

console.log({ part1: firstCalcPos.horizontal * firstCalcPos.vertical, part2: secondCalcPos.horizontal * secondCalcPos.vertical });
