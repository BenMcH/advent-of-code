package day10

import (
	"advent-of-code-2023/utils"
	"fmt"
	"slices"
	"strings"
	"testing"
)

func canStepLeft(grid utils.Grid, loc utils.Point) bool {
	point, ok := grid.Data[loc.Left()]

	return ok && strings.ContainsRune("LF-S", point)
}
func canStepRight(grid utils.Grid, loc utils.Point) bool {
	point, ok := grid.Data[loc.Right()]

	return ok && strings.ContainsRune("-J7S", point)
}
func canStepUp(grid utils.Grid, loc utils.Point) bool {
	point, ok := grid.Data[loc.Up()]

	return ok && strings.ContainsRune("|7FS", point)
}
func canStepDown(grid utils.Grid, loc utils.Point) bool {
	point, ok := grid.Data[loc.Down()]

	return ok && strings.ContainsRune("S|JL", point)
}

func viableNeighbors(grid utils.Grid, pos utils.Point) []utils.Point {
	n := make([]utils.Point, 0)

	t := grid.Data[pos]

	if strings.ContainsRune("7|SF", t) && canStepDown(grid, pos) {
		n = append(n, pos.Down())
	}
	if strings.ContainsRune("J|SL", t) && canStepUp(grid, pos) {
		n = append(n, pos.Up())
	}
	if strings.ContainsRune("7JS-", t) && canStepLeft(grid, pos) {
		n = append(n, pos.Left())
	}
	if strings.ContainsRune("L-SF", t) && canStepRight(grid, pos) {
		n = append(n, pos.Right())
	}

	return n
}

func testLoop(grid utils.Grid, points []utils.Point) (bool, []utils.Point) {
	neighbors := viableNeighbors(grid, points[len(points)-1])
	unvisited := utils.Filter(neighbors, func(p utils.Point, i int) bool { return !slices.Contains(points, p) })

	if len(neighbors) == 2 {
		if len(unvisited) == 0 {
			return true, points
		} else if len(unvisited) == 1 {
			return testLoop(grid, append(points, unvisited[0]))
		}
	}

	return false, make([]utils.Point, 0)
}

func partOne(input string) (int, []utils.Point) {
	grid := utils.MakeGrid(input)

	sLoc := utils.Point{}
	for key, val := range grid.Data {
		if val == 'S' {
			sLoc = key
			break
		}
	}
	sNeighbors := viableNeighbors(grid, sLoc)
	loop := make([]utils.Point, 0)

	for _, neighbor := range sNeighbors {
		if ok, iLoop := testLoop(grid, []utils.Point{sLoc, neighbor}); ok {
			loop = iLoop
			break
		}
	}

	return len(loop) / 2, loop
}

func TestPartOne(t *testing.T) {
	input := utils.ReadInput(10)
	dist, loop := partOne(input)
	fmt.Println(dist)
	grid := utils.MakeGrid(input)

	for y := grid.MinY; y <= grid.MaxY; y++ {
		for x := grid.MinX; x <= grid.MaxX; x++ {
			loc := utils.Point{X: x, Y: y}
			if !slices.Contains(loop, loc) {
				grid.Data[loc] = '.'
			}
		}
	}

	count := 0
	for y := grid.MinY; y <= grid.MaxY; y++ {
		inside := false
		openingCorner := ' '
		for x := grid.MinX; x <= grid.MaxX; x++ {
			loc := utils.Point{X: x, Y: y}
			cell := grid.Data[loc]
			if cell == '|' {
				inside = !inside
			} else if strings.ContainsRune("LF", cell) {
				openingCorner = cell
			} else if strings.ContainsRune("7J", cell) {
				if (openingCorner == 'L' && cell == '7') || (openingCorner == 'F' && cell == 'J') {
					inside = !inside
				}
			} else if inside && cell == '.' {
				count++
			}
		}
	}

	fmt.Println(count)
}
