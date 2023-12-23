package day23

import (
	"advent-of-code-2023/utils"
	"fmt"
	"maps"
	"strings"
	"testing"
)

const TEST_INPUT = `
#.#####################
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
				continue
			}
			neighbors = append(neighbors, neighbor)
		}

		if len(neighbors) > 1 {
			forked = true
			maxVal := 0

			for _, neighbor := range neighbors {
				maxVal = max(maxVal, walk(grid, neighbor, newPath))
			}

			return maxVal
		} else if len(neighbors) == 1 {
			point = neighbors[0]
			newPath.Add(point)
		} else {
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

func findIntersections(grid utils.Grid, startingPoint, endingPoint utils.Point) utils.Set[utils.Point] {
	visited := utils.Set[utils.Point]{}
	points := utils.Set[utils.Point]{}
	points.Add(startingPoint)
	points.Add(endingPoint)

	queue := make([]utils.Point, 0)
	queue = append(queue, startingPoint)
	var point utils.Point

	for len(queue) > 0 {
		point, queue = queue[0], queue[1:]
		if visited.Has(point) {
			continue
		}

		neighbors := make([]utils.Point, 0)

		for _, neighbor := range point.Neighbors4() {
			if !grid.ContainsPoint(neighbor) {
				continue
			}
			if grid.Data[neighbor] == '#' {
				continue
			}

			neighbors = append(neighbors, neighbor)
		}

		visited.Add(point)

		if len(neighbors) > 2 {
			points.Add(point)
		}

		queue = append(queue, neighbors...)
	}

	return points
}

type GraphEdge struct {
	destination utils.Point
	distance    int
}

func makeGraph(grid utils.Grid, points utils.Set[utils.Point]) map[utils.Point]utils.Set[GraphEdge] {
	graph := make(map[utils.Point]utils.Set[GraphEdge])

	for point := range points {
		graph[point] = make(utils.Set[GraphEdge])
		queue := []GraphEdge{
			{destination: point, distance: 0},
		}
		visited := make(utils.Set[utils.Point])
		visited.Add(point)

		for len(queue) > 0 {
			edge := queue[0]
			queue = queue[1:]

			if edge.distance > 0 && points.Has(edge.destination) {
				graph[point].Add(edge)
				continue
			}

			for _, neighbor := range edge.destination.Neighbors4() {
				if !grid.ContainsPoint(neighbor) {
					continue
				}
				if grid.Data[neighbor] == '#' {
					continue
				}
				if visited.Has(neighbor) {
					continue
				}
				queue = append(queue, GraphEdge{destination: neighbor, distance: edge.distance + 1})
				visited.Add(neighbor)
			}
		}
	}

	return graph
}

func walkGraph(graph map[utils.Point]utils.Set[GraphEdge], startingPoint, endingPoint utils.Point, path utils.Set[utils.Point]) int {
	if startingPoint == endingPoint {
		total := 0

		return total
	}

	maxVal := 0

	for neighbor := range graph[startingPoint] {
		if path.Has(neighbor.destination) {
			continue
		}
		path.Add(neighbor.destination)
		maxVal = max(maxVal, neighbor.distance+walkGraph(graph, neighbor.destination, endingPoint, path))
		path.Delete(neighbor.destination) // making new sets of points every time took ages
	}

	return maxVal
}

func partTwo(input string) int {
	grid := utils.MakeGrid(input)

	startingPoint := utils.Point{X: 1, Y: 0}
	endingPoint := utils.Point{X: grid.MaxX - 1, Y: grid.MaxY}
	intersections := findIntersections(grid, startingPoint, endingPoint)
	mappings := makeGraph(grid, intersections)

	return walkGraph(mappings, startingPoint, endingPoint, utils.Set[utils.Point]{})
}

func TestPartTwo(t *testing.T) {
	got := partTwo(TEST_INPUT)

	expected := 154

	if got != expected {
		t.Error("Wrong", got, "Expected", expected)
		return
	}

	fmt.Println(partTwo(utils.ReadInput(23)))
}
