package intcode

import (
	"advent-of-code-2019/utils"
	"fmt"
	"strings"
)

const (
	ADD            = 1
	MULTIPLY       = 2
	INPUT          = 3
	OUTPUT         = 4
	END_OF_PROGRAM = 99
)

func ExecuteIntcodeFromString(intcode string) ([]int, []int) {
	program, _ := utils.StringsToInts(strings.Split(intcode, ","))
	return ExecuteIntcode(program)
}

func ExecuteIntcode(intcode []int) (program []int, output []int) {
	program = make([]int, len(intcode))
	copy(program, intcode)

	output = []int{}

	pos := 0
	for pos < len(program) {
		memoryValue := program[pos]
		opcode := memoryValue % 100
		memoryValue -= opcode
		memoryValue /= 100

		parameterModes := []int{}

		for memoryValue != 0 {
			parameterMode := memoryValue % 10
			parameterModes = append(parameterModes, parameterMode)
			memoryValue = (memoryValue - parameterMode) / 10
		}

		fmt.Printf("Opcode: %d, modes: %v, pos: %d\n", opcode, parameterModes, pos)

		switch opcode {
		case ADD:
			args := program[pos : pos+4]
			a, b, nPos := args[1], args[2], args[3]
			fmt.Println(args[1:], a, b)
			if len(parameterModes) == 0 || parameterModes[0] == 0 {
				a = program[a]
				parameterModes = utils.Pop(parameterModes)
			}
			if len(parameterModes) == 0 || parameterModes[0] == 0 {
				b = program[b]
				// parameterModes = utils.Pop(parameterModes)
			}
			// fmt.Println(args[1:], a, b)
			// if len(parameterModes) == 0 || parameterModes[0] == 0 {
			// 	nPos = program[nPos]
			// }
			// a, b, nPos = program[args[1]], program[args[2]], args[3]
			program[nPos] = a + b
			pos += 4
		case MULTIPLY:
			args := program[pos : pos+4]
			a, b, nPos := args[1], args[2], args[3]
			if len(parameterModes) == 0 || parameterModes[0] == 0 {
				a = program[a]
				parameterModes = utils.Pop(parameterModes)
			}
			if len(parameterModes) == 0 || parameterModes[0] == 0 {
				b = program[b]
			}
			program[nPos] = a * b
			pos += 4
		case INPUT:
			input := 1
			param := program[pos+1]
			pos += 2

			program[param] = input
		case OUTPUT:
			param := program[pos+1]
			value := param

			if len(parameterModes) == 0 || parameterModes[0] == 0 {
				value = program[value]
			}
			pos += 2

			output = append(output, value)
		case END_OF_PROGRAM:
			pos = len(program)
		default:
			panic(fmt.Sprintf("Unknown opcode %d", program[pos]))
		}
	}

	return program, output
}
