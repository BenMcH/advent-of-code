package day14

import (
	"advent-of-code-2023/utils"
	"fmt"
	"strings"
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

/*
	1 2 3
	4 5 6
	7 8 9

	7 4 1
	8 5 2
	9 6 3

	9 8 7
	6 5 4
	3 2 1
*/

func rotate(input [][]rune) [][]rune {
	newGrid := make([][]rune, len(input[0]))

	for i := range newGrid {
		newGrid[i] = make([]rune, len(input))
	}

	for i := range newGrid {
		for j := range newGrid[i] {
			newGrid[i][j] = input[len(newGrid)-1-j][i]
		}
	}

	return newGrid
}

func TestRotate(t *testing.T) {
	input := get2dGrid("123\n456\n789")
	printGrid(rotate(input))
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

func spinCycle(input [][]rune) [][]rune {
	for i := 0; i < 4; i++ {
		input = tiltNorth(input)
		input = rotate(input)
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
	grid := get2dGrid(input)
	grid = tiltNorth(grid)

	fmt.Println(countLoad(grid))
}

func printGrid(grid [][]rune) {
	fmt.Println("----")
	for _, row := range grid {
		fmt.Println(string(row))
	}

}

func toString(input [][]rune) string {
	var builder strings.Builder

	for _, arr := range input {
		builder.WriteString(string(arr))
		builder.WriteRune('\n')
	}

	return builder.String()
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
	grid := get2dGrid(input)
	target := 1000000000
	for i := 0; i < target; i++ {
		grid = spinCycle(grid)
		if val, ok := cache[toString(grid)]; ok {
			i = (target - i) % (i - val)
			i = target - i
		}
		cache[toString(grid)] = i
	}

	fmt.Println(countLoad(grid))
}
