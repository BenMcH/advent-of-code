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

func dijkstra(grid utils.Grid, startingPoint utils.Point) map[Move]int {
	distances := make(map[Move]int)
	queue := make([]Move, 0)

	startingDir := utils.Point{X: 1, Y: 0}

	move := Move{
		loc:      startingPoint,
		dir:      startingDir,
		straight: 0,
	}

	distances[move] = 0
	queue = append(queue, move)

	for len(queue) > 0 {
		move, queue = queue[0], queue[1:]

		for _, neighbor := range move.loc.Neighbors4() {
			if !grid.ContainsPoint(neighbor) {
				continue
			}

			newDir := utils.Point{
				X: neighbor.X - move.loc.X,
				Y: neighbor.Y - move.loc.Y,
			}

			if math.Abs(float64(newDir.X)) > 1 || math.Abs(float64(newDir.Y)) > 1 {
				panic(newDir)
			}

			if newDir == move.dir.Multiply(-1) {
				continue // Can't turn around
			}

			nextMove := Move{
				loc:      neighbor,
				dir:      newDir,
				straight: 1,
			}

			if newDir == move.dir {
				nextMove.straight = move.straight + 1
			}

			if nextMove.straight > 3 {
				continue
			}

			newDist := distances[move] + int(grid.Data[nextMove.loc])

			if val, ok := distances[nextMove]; ok {
				if newDist >= val {
					continue
				}
			}
			distances[nextMove] = newDist

			queue = append(queue, nextMove)
		}

	}

	return distances
}

func parseInput(input string) (grid utils.Grid) {
	grid = utils.MakeGrid(input)

	// parse runes to int values
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

func PartOne(input string) int {
	grid := parseInput(input)
	startPoint := utils.Point{X: 0, Y: 0}

	distances := dijkstra(grid, startPoint)

	exitPoint := utils.Point{X: grid.MaxX, Y: grid.MaxY}
	minHeatloss := utils.IntPow(2, 50)

	for key, val := range distances {
		if key.loc == exitPoint && val < minHeatloss {
			minHeatloss = val
		}
	}

	return minHeatloss
}

func TestPartOne(t *testing.T) {

	got := PartOne(TEST_INPUT)

	if got != 102 {
		t.Error("Wrong", got, "Expected", 102)
	} else {
		fmt.Println(PartOne(REAL_INPUT))
	}
}
