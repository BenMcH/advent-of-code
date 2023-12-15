package day14

import (
	"advent-of-code-2023/utils"
	"fmt"
	"testing"
)

const (
	ROLLING_STONE = 'O'
	STATIC_STONE  = '#'
	EMPTY_SPACE   = '.'
)

func tiltNorth(input [][]rune) [][]rune {
	newGrid := make([][]rune, len(input))

	for i := range newGrid {
		newGrid[i] = make([]rune, len(input[i]))
		copy(newGrid[i], input[i])
	}

	for i := range newGrid {
		for j, ch := range newGrid[i] {
			if ch == ROLLING_STONE {
				newGrid[i][j] = EMPTY_SPACE
				for newRow := i; newRow >= 0; newRow-- {
					if newRow == 0 || newGrid[newRow-1][j] != EMPTY_SPACE {
						newGrid[newRow][j] = ROLLING_STONE
						break
					}
				}
			}
		}
	}

	return newGrid
}

func spinCycle(input [][]rune) [][]rune {
	for i := 0; i < 4; i++ {
		input = tiltNorth(input)
		input = utils.Rotate2dSlice(input)
	}

	return input
}

func countLoad(grid [][]rune) int {
	sum := 0

	for i := range grid {
		dist := len(grid) - i
		for j := range grid[i] {
			if grid[i][j] == ROLLING_STONE {
				sum += dist
			}
		}
	}

	return sum
}

func TestPartOne(t *testing.T) {
	input := `OOOO.#.O..
OO..#....#
OO..O##..O
O..#.OO...
........#.
..#....#.#
..O..#.O.O
..O.......
#....###..
#....#....
`

	input = utils.ReadInput(14)
	grid := utils.Get2DRuneSlice(input)
	grid = tiltNorth(grid)

	fmt.Println(countLoad(grid))
}

func printGrid(grid [][]rune) {
	fmt.Println("----")
	for _, row := range grid {
		fmt.Println(string(row))
	}

}

func TestPartTwo(t *testing.T) {
	input := `OOOO.#.O..
OO..#....#
OO..O##..O
O..#.OO...
........#.
..#....#.#
..O..#.O.O
..O.......
#....###..
#....#....
`

	cache := make(map[string]int)
	input = utils.ReadInput(14)
	grid := utils.Get2DRuneSlice(input)
	target := 1000000000
	jumped := false
	for i := 0; i < target; i++ {
		grid = spinCycle(grid)
		if val, ok := cache[utils.TwoDimensionalSliceToString(grid)]; ok && !jumped {
			fmt.Println(val)
			jumped = true
			i = (target - i) % (i - val)
			i = target - i
		}
		cache[utils.TwoDimensionalSliceToString(grid)] = i
	}

	fmt.Println(countLoad(grid))
}
