package intcode

import (
	"advent-of-code-2019/utils"
	"fmt"
	"strings"
)

const (
	/*
		Opcode 1 adds together numbers read from two positions and stores the result in a third position.
		The three integers immediately after the opcode tell you these three positions
		- the first two indicate the positions from which you should read the input values
		- the third indicates the position at which the output should be stored.
	*/
	ADD = 1
	/*
		Opcode 2 works exactly like opcode 1, except it multiplies the two inputs instead of adding them.
		Again, the three integers after the opcode indicate where the inputs and outputs are, not their values.
	*/
	MULTIPLY = 2
	/*
		Opcode 3 takes a single integer as input and saves it to the position given by its only parameter.
		For example, the instruction 3,50 would take an input value and store it at address 50.
	*/
	INPUT = 3
	/*
		Opcode 4 outputs the value of its only parameter. For example, the instruction 4,50 would output the value at address 50.
	*/
	OUTPUT = 4
	/*
		Opcode 5 is jump-if-true: if the first parameter is non-zero, it sets the instruction pointer to the value from the second parameter. Otherwise, it does nothing.
	*/
	JUMP_IF_TRUE = 5
	/*
		Opcode 6 is jump-if-false: if the first parameter is zero, it sets the instruction pointer to the value from the second parameter. Otherwise, it does nothing.
	*/
	JUMP_IF_FALSE = 6
	/*
		Opcode 7 is less than: if the first parameter is less than the second parameter, it stores 1 in the position given by the third parameter. Otherwise, it stores 0.
	*/
	LESS_THAN = 7
	/*
		Opcode 8 is equals: if the first parameter is equal to the second parameter, it stores 1 in the position given by the third parameter. Otherwise, it stores 0.
	*/
	EQUALS         = 8
	END_OF_PROGRAM = 99
)

/*
Parameter modes

0 - Default. position mode == causes the parameter to be interpreted as a position - if the parameter is 50, its value is the value stored at address 50 in memory.
1 - Immediate Mode == In immediate mode, a parameter is interpreted as a value - if the parameter is 50, its value is simply 50.

Parameter modes are stored in the same value as the instruction's opcode.
The opcode is a two-digit number based only on the ones and tens digit of the value, that is, the opcode is the rightmost two digits of the first value in an instruction.
Parameter modes are single digits, one per parameter, read right-to-left from the opcode: the first parameter's mode is in the hundreds digit, the second parameter's mode is in the thousands digit,
the third parameter's mode is in the ten-thousands digit, and so on. Any missing modes are 0.

Parameters that an instruction writes to will never be in immediate mode.
*/

func ExecuteIntcodeFromString(intcode string, input []int) (program []int, output []int) {
	prg, _ := utils.StringsToInts(strings.Split(intcode, ","))
	return ExecuteIntcode(prg, input)
}

func ExecuteIntcode(intcode []int, input []int) (program []int, output []int) {
	program = make([]int, len(intcode))
	copy(program, intcode)

	output = []int{}

	pos := 0
	for pos < len(program) {
		memoryValue := program[pos]
		opcode := memoryValue % 100
		parameterModes := (memoryValue - opcode) / 100

		switch opcode {
		case ADD:
			args := program[pos : pos+4]
			a, b, nPos := args[1], args[2], args[3]
			mode := parameterModes % 10
			parameterModes /= 10
			if mode == 0 {
				a = program[a]
			}
			mode = parameterModes % 10
			parameterModes /= 10
			if mode == 0 {
				b = program[b]
			}
			program[nPos] = a + b
			pos += 4
		case MULTIPLY:
			args := program[pos : pos+4]
			a, b, nPos := args[1], args[2], args[3]
			mode := parameterModes % 10
			parameterModes /= 10
			if mode == 0 {
				a = program[a]
			}
			mode = parameterModes % 10
			parameterModes /= 10
			if mode == 0 {
				b = program[b]
			}
			program[nPos] = a * b
			pos += 4
		case INPUT:
			inputVal := input[0]
			input = utils.Pop(input)
			param := program[pos+1]
			pos += 2

			program[param] = inputVal
		case OUTPUT:
			param := program[pos+1]
			value := param
			mode := parameterModes % 10
			parameterModes /= 10

			if mode == 0 {
				value = program[value]
			}
			pos += 2

			output = append(output, value)
		case JUMP_IF_TRUE:
			args := program[pos : pos+3]
			a, b := args[1], args[2]
			mode := parameterModes % 10
			parameterModes /= 10
			if mode == 0 {
				a = program[a]
			}
			mode = parameterModes % 10
			parameterModes /= 10
			if mode == 0 {
				b = program[b]
			}

			if a != 0 {
				pos = b
			} else {
				pos += 3
			}
		case JUMP_IF_FALSE:
			args := program[pos : pos+3]
			a, b := args[1], args[2]
			mode := parameterModes % 10
			parameterModes /= 10
			if mode == 0 {
				a = program[a]
			}
			mode = parameterModes % 10
			parameterModes /= 10
			if mode == 0 {
				b = program[b]
			}

			if a == 0 {
				pos = b
			} else {
				pos += 3
			}
		case LESS_THAN:
			args := program[pos : pos+4]
			a, b, nPos := args[1], args[2], args[3]
			mode := parameterModes % 10
			parameterModes /= 10
			if mode == 0 {
				a = program[a]
			}
			mode = parameterModes % 10
			parameterModes /= 10
			if mode == 0 {
				b = program[b]
			}
			if a < b {
				program[nPos] = 1
			} else {
				program[nPos] = 0
			}
			pos += 4
		case EQUALS:
			args := program[pos : pos+4]
			a, b, nPos := args[1], args[2], args[3]
			mode := parameterModes % 10
			parameterModes /= 10
			if mode == 0 {
				a = program[a]
			}
			mode = parameterModes % 10
			parameterModes /= 10
			if mode == 0 {
				b = program[b]
			}
			if a == b {
				program[nPos] = 1
			} else {
				program[nPos] = 0
			}
			pos += 4
		case END_OF_PROGRAM:
			pos = len(program)
		default:
			panic(fmt.Sprintf("Unknown opcode %d", program[pos]))
		}
	}

	return program, output
}
