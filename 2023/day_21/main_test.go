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
	count, _ := walk(grid, []utils.Point{pt}, distance, false)

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

func negMod(a, b int) int {
	mod := a % b

	if mod < 0 {
		mod += b
	}

	return mod
}

func walk(grid utils.Grid, points []utils.Point, dist int, partTwo bool) (int, map[utils.Point]int) {
	m := make(map[utils.Point]int)
	originalDistance := dist
	for {
		if dist == 0 {
			evens, odds := 0, 0

			for _, v := range m {
				if (v % 2) == 0 {
					evens++
				} else {
					odds++
				}
			}

			if originalDistance%2 == 0 {
				return odds, m
			}
			return evens, m
		}

		newPoints := make([]utils.Point, 0)

		for _, currPoint := range points {
			for _, neighbor := range currPoint.Neighbors4() {
				var symbolicPoint = neighbor.Copy()
				if partTwo {
					symbolicPoint.X = negMod(symbolicPoint.X, grid.MaxX+1)
					symbolicPoint.Y = negMod(symbolicPoint.Y, grid.MaxY+1)
				} else {
					if !grid.ContainsPoint(neighbor) {
						continue
					}
				}

				if _, ok := m[neighbor]; ok {
					continue // visited
				}

				if grid.Data[symbolicPoint] == '#' {
					continue
				}
				m[neighbor] = originalDistance - dist

				newPoints = append(newPoints, neighbor)
			}
		}
		points = newPoints

		dist--
	}
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

func partTwo(input string, distance int) int {
	grid := utils.MakeGrid(input)
	var pt utils.Point

	for key, val := range grid.Data {
		if val == 'S' {
			pt = key
		}
	}
	maxI := 3
	points := make([]int, maxI)
	n := 65
	for i := 0; i < maxI; i++ {
		n = (grid.MaxX / 2) + (grid.MaxX+1)*i
		points[i], _ = walk(grid, []utils.Point{pt}, n, true)
	}

	deltas := make([]int, len(points)-1)
	for i := 0; i < len(points)-1; i++ {
		deltas[i] = points[i+1] - points[i]
	}

	x := (distance - (grid.MaxX / 2)) / (grid.MaxX + 1)

	// f(x)= ax^2+bx+c

	c := points[0]

	f1 := points[1]

	f2 := points[2]
	// a + b = f1 - c

	// f(1) = a + b + c
	// f(1) - c = a + b
	aPlusB := f1 - c

	// f(2) = 4a + 2b + c
	// f(2) - c = 4a + 2b
	// (f(2) - c)/2 = 2a + b
	fourAPlusTwoB := f2 - c
	twoAPlusB := fourAPlusTwoB / 2

	a, b := 1, 1

	for a < aPlusB {
		b = aPlusB - a
		ans := 2*a + b

		if ans == twoAPlusB {
			break
		}
		a++
	}

	return a*(x*x) + b*x + c
}

func TestPartTwo(t *testing.T) {
	fmt.Println(partTwo(utils.ReadInput(21), 26501365))
}
