package day11

import (
	"advent-of-code-2023/utils"
	"fmt"
	"testing"
)

func galacticDistances(input string, offset int) int {
	lines := utils.Lines(input)

	gal := utils.Map(lines, func(input string, idx int) []rune { return []rune(input) })

	cells := make([]utils.Point, 0)

	symbolicY, symbolicX := 0, 0
	for _, line := range gal {
		if utils.All(line, func(r rune) bool { return r == '.' }) {
			symbolicY = symbolicY + offset
			continue
		}

		symbolicX = 0
		for x, pt := range line {
			if utils.All(gal, func(r []rune) bool { return r[x] == '.' }) {
				symbolicX = symbolicX + offset
				continue
			}

			if pt == '#' {
				cells = append(cells, utils.Point{symbolicX, symbolicY})
			}
			symbolicX++
		}
		symbolicY++
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
	got := galacticDistances(`...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....
`, 2)

	if got != 374 {
		t.Error("Wrong", got)
	} else {
		fmt.Println(galacticDistances(utils.ReadInput(11), 2))
	}
}

func TestPartTwo(t *testing.T) {
	got := galacticDistances(`...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....
`, 100)

	if got != 8410 {
		t.Error("Wrong", got)
	} else {
		fmt.Println(galacticDistances(utils.ReadInput(11), 1000000))
	}
}
