package day18

import (
	"advent-of-code-2023/utils"
	"fmt"
	"slices"
	"strconv"
	"strings"
	"testing"
)

const TEST_INPUT = `R 6 (#70c710)
D 5 (#0dc571)
L 2 (#5713f0)
D 2 (#d2c081)
R 2 (#59c680)
D 2 (#411b91)
L 5 (#8ceee2)
U 2 (#caa173)
L 1 (#1b58a2)
U 2 (#caa171)
R 2 (#7807d2)
U 3 (#a77fa3)
L 2 (#015232)
U 2 (#7a21e3)
`

var REAL_INPUT = utils.ReadInput(18)

func findEmpty(grid [][]rune) utils.Point {
	firstCell := utils.Point{}

	for y, row := range grid {
		if y == 0 {
			continue
		}
		for x := 0; x < len(row)-1; x++ {
			if row[x] == '#' {
				if row[x+1] == '.' {
					firstCell.X = x + 1
					firstCell.Y = y

					return firstCell
				}
				continue
			}
		}
	}

	return firstCell
}

func flood(grid [][]rune) {
	cellsToFlood := make([]utils.Point, 0)
	cell := findEmpty(grid)

	cellsToFlood = append(cellsToFlood, cell)

	for len(cellsToFlood) > 0 {
		fmt.Println(len(cellsToFlood))
		cell, cellsToFlood = cellsToFlood[0], cellsToFlood[1:]
		grid[cell.Y][cell.X] = '#'

		for _, pt := range cell.Neighbors4() {
			if grid[pt.Y][pt.X] == '#' || slices.Contains(cellsToFlood, pt) {
				continue
			}
			cellsToFlood = append(cellsToFlood, pt)
		}
	}
}

func PartOne(input string) int {
	point := utils.Point{X: 0, Y: 0}
	digsites := make(map[utils.Point]rune)

	lines := utils.Lines(input)

	dirMap := map[string]utils.Point{
		"L": point.Left(),
		"R": point.Right(),
		"U": point.Up(),
		"D": point.Down(),
	}

	minX, minY := 0, 0
	maxX, maxY := 0, 0

	for _, line := range lines {
		parts := strings.Split(line, " ")
		dir := dirMap[parts[0]]
		dist, _ := strconv.Atoi(parts[1])

		for dist > 0 {
			digsites[point] = '#'
			point = point.Add(dir)
			dist--
		}

		if point.X > maxX {
			maxX = point.X
		} else if point.X < minX {
			minX = point.X
		}

		if point.Y > maxY {
			maxY = point.Y
		} else if point.Y < minY {
			minY = point.Y
		}
	}

	fmt.Println(minX, maxX, minY, maxY)

	arr := make([][]rune, maxY-minY+1)

	for y := range arr {
		arr[y] = make([]rune, maxX-minX+1)
		point.Y = y + minY

		for x := range arr[y] {
			point.X = x + minX

			if digsites[point] == '#' {
				arr[y][x] = '#'
			} else {
				arr[y][x] = '.'
			}
			// fmt.Print(string(arr[y][x]))
		}
		// fmt.Println()
	}

	flood(arr)

	count := 0

	for _, row := range arr {
		for _, cell := range row {
			if cell == '#' {
				count++
			}
		}
	}
	return count
}

func TestPartOne(t *testing.T) {
	got := PartOne(TEST_INPUT)

	if got != 62 {
		t.Error("Wrong", got, "Expected", 62)
		return
	}
	fmt.Println("HERE")

	fmt.Println(PartOne(REAL_INPUT))
}
