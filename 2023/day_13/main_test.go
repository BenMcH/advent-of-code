package day13

import (
	"advent-of-code-2023/utils"
	"fmt"
	"strings"
	"testing"
)

func getSplitScore(pattern string) int {
	lines := utils.Lines(pattern)

	for i := 0; i < len(lines)-1; i++ {
		currLine := lines[i]
		nextLine := lines[i+1]

		if currLine == nextLine {
			up, down := i, i+1

			symmetric := true
			for symmetric && up >= 0 && down < len(lines) {
				currLine = lines[up]
				nextLine = lines[down]
				if currLine != nextLine {
					symmetric = false
				}
				down++
				up--
			}
			if symmetric {
				return 100 * (i + 1)
			}
		}
	}

	colLines := utils.Transpose(utils.Map(lines, func(s string, i int) []rune { return []rune(s) }))
	colStrs := utils.Map(colLines, func(r []rune, i int) string { return string(r) })

	for i := 0; i < len(colStrs)-1; i++ {
		currLine := colStrs[i]
		nextLine := colStrs[i+1]

		if currLine == nextLine {
			up, down := i, i+1

			symmetric := true
			for symmetric && up >= 0 && down < len(colStrs) {
				currLine = colStrs[up]
				nextLine = colStrs[down]
				if currLine != nextLine {
					symmetric = false
				}
				down++
				up--
			}
			if symmetric {
				return i + 1
			}
		}
	}

	panic("no repeat found")
}

func TestPartOne(t *testing.T) {
	patterns := strings.Split(utils.ReadInput(13), "\n\n")
	scores := make([]int, len(patterns))

	for i, pattern := range patterns {
		scores[i] = getSplitScore(pattern)
	}

	fmt.Println(utils.SumIntArr(scores))

}
