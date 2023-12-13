package day13

import (
	"advent-of-code-2023/utils"
	"fmt"
	"strings"
	"testing"
)

func countDifferences(a, b string) int {
	count := 0

	for i := range a {
		if a[i] != b[i] {
			count++
		}
	}

	return count
}

func findReflection(lines []string, expectedDifference int) int {
	for i := 0; i < len(lines)-1; i++ {
		currLine := lines[i]
		nextLine := lines[i+1]
		diff := expectedDifference

		currDiff := countDifferences(currLine, nextLine)
		diff -= currDiff
		if diff >= 0 {
			up, down := i-1, i+2

			symmetric := true
			for symmetric && up >= 0 && down < len(lines) {
				currLine = lines[up]
				nextLine = lines[down]
				diff -= countDifferences(currLine, nextLine)
				if diff < 0 {
					symmetric = false
				}
				down++
				up--
			}
			if symmetric && diff == 0 {
				return (i + 1)
			}
		}
	}

	return 0
}

func getSplitScore(pattern string, expectedDifferences int) int {
	lines := utils.Lines(pattern)

	reflection := findReflection(lines, expectedDifferences) * 100

	if reflection == 0 {
		colLines := utils.Transpose(utils.Map(lines, func(s string, i int) []rune { return []rune(s) }))
		colStrs := utils.Map(colLines, func(r []rune, i int) string { return string(r) })

		reflection = findReflection(colStrs, expectedDifferences)
	}

	return reflection
}

func TestPartOne(t *testing.T) {
	input := `#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#
`
	input = utils.ReadInput(13)
	patterns := strings.Split(input, "\n\n")
	scores := make([]int, len(patterns))

	for i, pattern := range patterns {
		scores[i] = getSplitScore(pattern, 0)
	}

	fmt.Println(utils.SumIntArr(scores))

}

func TestPartTwo(t *testing.T) {
	input := `#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#
`
	input = utils.ReadInput(13)
	patterns := strings.Split(input, "\n\n")
	scores := make([]int, len(patterns))

	for i, pattern := range patterns {
		scores[i] = getSplitScore(pattern, 1)
	}

	fmt.Println(utils.SumIntArr(scores))
}
