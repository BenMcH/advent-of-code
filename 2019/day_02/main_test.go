package day_02

import (
	"advent-of-code-2019/intcode"
	"advent-of-code-2019/utils"
	"strings"
	"testing"
)

func TestPartOne(t *testing.T) {
	got, _ := intcode.ExecuteIntcodeFromString("1,1,1,4,99,5,6,0,99")

	if got[0] != 30 {
		t.Errorf("Got: %d, expected: 30", got)
		return
	}

	input := utils.ReadFile("./input.txt")

	answer, _ := PartOne(input)

	t.Logf("Day 1 Part 1: %d", answer)
}

func TestPartTwo(t *testing.T) {
	input := utils.ReadFile("./input.txt")
	originalProgram, _ := utils.StringsToInts(strings.Split(input, ","))

	for noun := 1; noun < len(originalProgram)-1; noun += 1 {
		for verb := 0; verb < len(originalProgram)-1; verb += 1 {
			program, _ := utils.StringsToInts(strings.Split(input, ","))

			program[1] = noun
			program[2] = verb
			program, _ = intcode.ExecuteIntcode(program)

			if program[0] == 19690720 {
				t.Logf("Day 2 Part 2: 100 * %d + %d = %d", noun, verb, 100*noun+verb)
				return
			}
		}
	}

}
