package day21

import (
	"advent-of-code-2023/utils"
	"fmt"
	"testing"
)

func partOne(input string, distance int) int {
	grid := utils.MakeGrid(input)
	var pt utils.Point

	for key, val := range grid.Data {
		if val == 'S' {
			pt = key
		}
	}
	count := walk(grid, []utils.Point{pt}, distance)

	return count
}

const TEST_INPUT = `...........
.....###.#.
.###.##..#.
..#.#...#..
....#.#....
.##..S####.
.##..#...#.
.......##..
.##.#.####.
.##..##.##.
...........
`

func walk(grid utils.Grid, points []utils.Point, dist int) int {
	m := make(map[utils.Point]int)

	for _, p := range points {
		m[p]++
	}
	if dist == 0 {
		return len(m)
	}

	newPoints := make(map[utils.Point]int)

	points = make([]utils.Point, 0)
	for currPoint := range m {
		for _, neighbor := range currPoint.Neighbors4() {
			if !grid.ContainsPoint(neighbor) || grid.Data[neighbor] == '#' {
				continue
			}

			if _, ok := newPoints[neighbor]; !ok {

				points = append(points, neighbor)
			}
			newPoints[neighbor]++
		}
	}

	return walk(grid, points, dist-1)
}

func TestPartOne(t *testing.T) {
	got := partOne(TEST_INPUT, 6)
	expected := 16

	if got != expected {
		t.Error("Expected", expected, "Got", got)
		return
	}

	fmt.Println(partOne(utils.ReadInput(21), 64))
}
