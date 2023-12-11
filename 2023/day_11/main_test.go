package day11

import (
	"advent-of-code-2023/utils"
	"fmt"
	"testing"
)

func expandSpaceRows(input [][]rune) [][]rune {
	newSpace := make([][]rune, 0)

	for _, row := range input {
		newSpace = append(newSpace, row)
		if utils.All(row, func(r rune) bool { return r == '.' }) {
			newSpace = append(newSpace, row)
		}
	}

	return newSpace
}

func partOne(input string) int {
	lines := utils.Lines(input)

	gal := utils.Map(lines, func(input string, idx int) []rune { return []rune(input) })

	gal = expandSpaceRows(gal)
	gal = utils.Transpose(gal)
	gal = expandSpaceRows(gal)
	gal = utils.Transpose(gal)

	cells := make([]utils.Point, 0)

	for y, line := range gal {
		for x, char := range line {
			if char == '#' {
				cells = append(cells, utils.Point{x, y})
			}
		}
	}

	sum := 0
	for i, pt := range cells {
		for _, pt2 := range cells[i+1:] {
			sum = sum + pt.ManhattenDistance(pt2)
		}
	}

	return sum

}

func TestPartOne(t *testing.T) {
	got := partOne(`...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....
`)

	if got != 374 {
		t.Error("Wrong", got)
	} else {
		fmt.Println(partOne(utils.ReadInput(11)))
	}
}
