package day17

import (
	"advent-of-code-2023/utils"
	"fmt"
	"math"
	"testing"
)

const TEST_INPUT = `2413432311323
3215453535623
3255245654254
3446585845452
4546657867536
1438598798454
4457876987766
3637877979653
4654967986887
4564679986453
1224686865563
2546548887735
4322674655533`

var REAL_INPUT = utils.ReadInput(17)

type Move struct {
	loc, dir utils.Point
	straight int
}

func dijkstra(grid utils.Grid, startingPoint utils.Point, shouldSkip func(grid utils.Grid, move, nextMove Move) bool) map[Move]int {
	distances := make(map[Move]int)

	costs := make([][]int, grid.MaxY+1)

	for y := grid.MinY; y <= grid.MaxY; y++ {
		costs[y] = make([]int, grid.MaxX+1)
		pt := utils.Point{X: 0, Y: y}
		for x := grid.MinX; x <= grid.MaxX; x++ {
			pt.X = x
			costs[y][x] = int(grid.Data[pt])
		}
	}

	move := Move{
		loc: startingPoint,
		dir: utils.Point{X: 1, Y: 0},
	}

	distances[move] = 0
	queue := []Move{move}

	for len(queue) > 0 {
		move, queue = queue[0], queue[1:]
		moveDist := distances[move]

		neighbors := move.loc.Neighbors4()

		for _, neighbor := range neighbors {
			if !grid.ContainsPoint(neighbor) {
				continue
			}
			nextMove := Move{
				loc:      neighbor,
				dir:      move.loc.Diff(neighbor),
				straight: 1,
			}

			if nextMove.dir == move.dir {
				nextMove.straight = move.straight + 1
			}

			if nextMove.dir == move.dir.Multiply(-1) || shouldSkip(grid, move, nextMove) {
				continue
			}

			newDist := moveDist + costs[nextMove.loc.Y][nextMove.loc.X]
			if val, ok := distances[nextMove]; ok && newDist >= val {
				continue
			}

			distances[nextMove] = newDist

			queue = append(queue, nextMove)
		}
	}

	return distances
}

func skipPartOne(grid utils.Grid, move, nextMove Move) bool {
	return nextMove.straight > 3
}

func parseInput(input string) (grid utils.Grid) {
	grid = utils.MakeGrid(input)

	for y := grid.MinY; y <= grid.MaxY; y++ {
		for x := grid.MinX; x <= grid.MaxX; x++ {
			pt := utils.Point{
				X: x,
				Y: y,
			}

			grid.Data[pt] = grid.Data[pt] - '0'
		}
	}

	return
}

var TEST_GRID = parseInput(TEST_INPUT)
var REAL_GRID = parseInput(REAL_INPUT)

func PartOne(grid utils.Grid) int {
	startPoint := utils.Point{X: 0, Y: 0}

	distances := dijkstra(grid, startPoint, skipPartOne)

	exitPoint := utils.Point{X: grid.MaxX, Y: grid.MaxY}

	minDist := math.MaxInt

	for k, v := range distances {
		if k.loc == exitPoint && v < minDist {
			minDist = v
		}
	}

	return minDist
}

func TestPartOne(t *testing.T) {

	got := PartOne(TEST_GRID)

	if got != 102 {
		t.Error("Wrong", got, "Expected", 102)
	} else {
		fmt.Println(PartOne(REAL_GRID))
	}
}

func skipPartTwo(grid utils.Grid, move, nextMove Move) bool {
	if move.straight > 0 && move.straight < 4 && nextMove.straight == 1 { // Check above 0 to avoid the first cell being counted as a turn
		return true
	}

	if nextMove.straight > 10 {
		return true
	}

	end := utils.Point{X: grid.MaxX, Y: grid.MaxY}

	if nextMove.loc == end && nextMove.straight < 4 {
		return true
	}

	return false
}

func PartTwo(grid utils.Grid) int {
	startPoint := utils.Point{X: 0, Y: 0}

	distances := dijkstra(grid, startPoint, skipPartTwo)

	exitPoint := utils.Point{X: grid.MaxX, Y: grid.MaxY}

	minDist := math.MaxInt

	for k, v := range distances {
		if k.loc == exitPoint && v < minDist {
			minDist = v
		}
	}

	return minDist
}

func TestPartTwo(t *testing.T) {

	got := PartTwo(TEST_GRID)

	if got != 94 {
		t.Error("Wrong", got, "Expected", 94)
	} else {
		fmt.Println(PartTwo(REAL_GRID))
	}
}
