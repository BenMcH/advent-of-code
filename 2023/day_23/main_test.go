package day23

import (
	"advent-of-code-2023/utils"
	"fmt"
	"maps"
	"strings"
	"testing"
)

const TEST_INPUT = `#.#####################
#.......#########...###
#######.#########.#.###
###.....#.>.>.###.#.###
###v#####.#v#.###.#.###
###.>...#.#.#.....#...#
###v###.#.#.#########.#
###...#.#.#.......#...#
#####.#.#.#######.#.###
#.....#.#.#.......#...#
#.#####.#.#.#########v#
#.#...#...#...###...>.#
#.#.#v#######v###.###v#
#...#.>.#...>.>.#.###.#
#####v#.#.###v#.#.###.#
#.....#...#...#.#.#...#
#.#########.###.#.#.###
#...###...#...#...#.###
###.###.#.###v#####v###
#...#...#.#.>.>.#.>.###
#.###.###.#.###.#.#v###
#.....###...###...#...#
#####################.#
`

var (
	BASELINE = utils.Point{X: 0, Y: 0}
	UP       = BASELINE.Up()
	DOWN     = BASELINE.Down()
	LEFT     = BASELINE.Left()
	RIGHT    = BASELINE.Right()
)

func walk(grid utils.Grid, startingPoint utils.Point, path utils.Set[utils.Point]) int {
	newPath := maps.Clone(path)
	newPath.Add(startingPoint)

	dirs := map[rune]utils.Point{
		'>': RIGHT,
		'<': LEFT,
		'^': UP,
		'v': DOWN,
	}

	forked := false
	point := startingPoint

	for !forked {
		neighbors := make([]utils.Point, 0)
		pointRune := grid.Data[point]

		for _, neighbor := range point.Neighbors4() {
			if newPath.Has(neighbor) || !grid.ContainsPoint(neighbor) {
				continue
			}
			if grid.Data[neighbor] == '#' {
				continue
			}
			diff := point.Diff(neighbor)

			if strings.ContainsRune("<^v>", pointRune) && diff != dirs[pointRune] {
				fmt.Println("Failed slope", point, diff)
				continue
			}
			neighbors = append(neighbors, neighbor)
		}

		if len(neighbors) > 1 {
			fmt.Println("Forking", point, neighbors)
			forked = true
			maxVal := 0

			for _, neighbor := range neighbors {
				maxVal = max(maxVal, walk(grid, neighbor, newPath))
			}

			return maxVal
		} else if len(neighbors) == 1 {
			fmt.Println(startingPoint, point)
			point = neighbors[0]
			newPath.Add(point)
		} else {
			fmt.Println("No More neighbors")
			// No more neighbors
			if point.Y == grid.MaxY && point.X == grid.MaxX-1 {
				return len(newPath) - 1
			}
			return 0
		}

	}

	return 0
}

func partOne(input string) int {
	grid := utils.MakeGrid(input)
	startingPoint := utils.Point{X: 1, Y: 0}

	fmt.Println(string(grid.Data[startingPoint]))

	return walk(grid, startingPoint, utils.Set[utils.Point]{})
}

func TestPartOne(t *testing.T) {
	got := partOne(TEST_INPUT)

	expected := 94

	if got != expected {
		t.Error("Wrong", got, "Expected", expected)
		return
	}

	fmt.Println(partOne(utils.ReadInput(23)))
}
