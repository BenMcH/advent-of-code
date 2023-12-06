package day05

import (
	"advent-of-code-2023/utils"
	"fmt"
	"strings"
	"testing"
)

func PartOne(input string) int {
	product := 1
	lines := utils.Lines(input)
	times := utils.NumbersFromString(lines[0])
	distances := utils.NumbersFromString(lines[1])

	for i, time := range times {
		count := 0
		target := distances[i]

		for j := 1; j < time; j++ {
			ans := j * (time - j)
			if ans > target {
				count++
			}
		}

		fmt.Println(count)
		product = product * count
	}

	return product
}

func PartTwo(input string) int {
	lines := utils.Lines(input)
	for i, line := range lines {
		lines[i] = strings.ReplaceAll(line, " ", "")
	}
	return PartOne(strings.Join(lines, "\n"))
}

func TestPartOne(t *testing.T) {
	testInput := `Time:      7  15   30
Distance:  9  40  200
`

	fmt.Println(PartOne(testInput))
	fmt.Println(PartOne(utils.ReadInput(6)))
}

func TestPartTwo(t *testing.T) {
	testInput := `Time:      7  15   30
Distance:  9  40  200
`

	fmt.Println(PartTwo(testInput))
	fmt.Println(PartTwo(utils.ReadInput(6)))
}
