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

	return Instruction{locs[0], locs[1], locs[2]}
}

func partOne(input string) int {
	sections := strings.Split(input, "\n\n")
	steps := []rune(strings.Trim(sections[0], "\n"))

	lines := utils.Lines(sections[1])

	instructions := utils.Map(lines, func(line string) Instruction {
		return parseInstruction(line)
	})

	instMap := utils.SliceToMap(instructions, func(i Instruction) string {
		return i.loc
	})

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

func partTwo(input string) int {
	sections := strings.Split(input, "\n\n")
	steps := []rune(strings.Trim(sections[0], "\n"))

	lines := utils.Lines(sections[1])

	instructions := utils.Map(lines, func(line string) Instruction {
		return parseInstruction(line)
	})

	locations := make([]Instruction, 0)
	instMap := utils.SliceToMap(instructions, func(i Instruction) string {
		if strings.HasSuffix(i.loc, "A") {
			locations = append(locations, i)
		}
		return i.loc
	})

	cycles := utils.Map(locations, func(location Instruction) int {
		step := 0

		for !strings.HasSuffix(location.loc, "Z") {
			currStep := steps[step%len(steps)]

			if currStep == 'R' {
				location = instMap[location.right]
			} else {
				location = instMap[location.left]
			}
			step++
		}

		return step
	})

	ans := utils.Reduce(cycles, 1, func(g, nextVal int) int {
		return utils.LCM(g, nextVal)
	})

	return ans
}

func TestPartTwo(t *testing.T) {
	testInput := `LR

FFA = (FFB, XXX)
FFB = (XXX, FFZ)
FFZ = (FFB, XXX)
GGA = (GGB, XXX)
GGB = (GGC, GGC)
GGC = (GGZ, GGZ)
GGZ = (GGB, GGB)
XXX = (XXX, XXX)
`
	if partTwo(testInput) != 6 {
		t.Error("Wrong", partTwo(testInput))
	} else {
		fmt.Println(partTwo(utils.ReadInput(8)))
	}
}
