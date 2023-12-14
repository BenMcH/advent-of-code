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

func get2dGrid(input string) [][]rune {
	lines := utils.Lines(input)

	return utils.Map(lines, func(str string, i int) []rune { return []rune(str) })
}

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
	grid := get2dGrid(input)
	grid = tiltNorth(grid)

	for _, row := range grid {
		fmt.Println(string(row))
	}

	fmt.Println(countLoad(grid))
}
