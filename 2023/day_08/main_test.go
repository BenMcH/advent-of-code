package day08

import (
	"advent-of-code-2023/utils"
	"fmt"
	"regexp"
	"strings"
	"testing"
)

type Instruction struct {
	loc   string
	left  string
	right string
}

func parseInstruction(input string) Instruction {
	locRegex := regexp.MustCompile(`\w+`)
	locs := locRegex.FindAllString(input, -1)

	if len(locs) != 3 {
		panic("Wrong number of locations")
	}

	return Instruction{locs[0], locs[1], locs[2]}
}

func partOne(input string) int {
	sections := strings.Split(input, "\n\n")
	steps := []rune(strings.Trim(sections[0], "\n"))

	lines := utils.Lines(sections[1])

	instructions := utils.Map(lines, func(line string) Instruction {
		return parseInstruction(line)
	})

	instMap := make(map[string]Instruction)

	for _, instruction := range instructions {
		instMap[instruction.loc] = instruction
	}

	step := 0
	loc := instMap["AAA"]

	for loc.loc != "ZZZ" {
		currStep := steps[step%len(steps)]

		if currStep == 'R' {
			loc = instMap[loc.right]
		} else {
			loc = instMap[loc.left]
		}

		step++
	}

	return step
}

func TestPartOne(t *testing.T) {
	testInput := `LLR

AAA = (BBB, BBB)
BBB = (AAA, ZZZ)
ZZZ = (ZZZ, ZZZ)
`

	if partOne(testInput) != 6 {
		t.Error("Wrong", partOne(testInput))
	} else {
		fmt.Println(partOne(utils.ReadInput(8)))
	}
}
