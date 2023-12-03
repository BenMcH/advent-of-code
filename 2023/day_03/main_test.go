package day_03

import (
	"advent-of-code-2023/utils"
	"fmt"
	"strconv"
	"testing"
	"unicode"
)

func ExtractNumberAt(grid utils.Grid, point utils.Point) string {
	point = utils.Point{X: point.X, Y: point.Y}

	for point.X > grid.MinX && unicode.IsDigit(grid.Data[point.Left()]) {
		point = point.Left()
	}

	runes := make([]rune, 0)
	runes = append(runes, grid.Data[point])

	for unicode.IsDigit(grid.Data[point.Right()]) {
		point = point.Right()
		runes = append(runes, grid.Data[point])
	}

	return string(runes)
}

func IsSymbol(input rune) bool {
	sym := input != '.' && !unicode.IsDigit(input)
	return sym
}

func FindPartNumbers(grid utils.Grid) []int {
	partNumbers := make([]int, 0)

	for row := grid.MinY; row <= grid.MaxY; row++ {
		for col := grid.MinX; col <= grid.MaxX; col++ {
			point := utils.Point{X: col, Y: row}
			char := grid.Data[point]
			isSurrounded := false

			if !unicode.IsNumber(char) {
				continue
			}

			neighbors := point.Neighbors8()

			for _, val := range neighbors {
				if rn, ok := grid.Data[val]; ok {
					if IsSymbol(rn) {
						isSurrounded = true
					}
				}
			}

			if isSurrounded {
				numberStr := ExtractNumberAt(grid, point)
				number, _ := strconv.Atoi(numberStr)

				partNumbers = append(partNumbers, number)

				for point.X < grid.MaxX && unicode.IsDigit(grid.Data[point.Right()]) {
					point = point.Right()
				}

				col = point.X
			}
		}
	}

	return partNumbers
}

func PartOne(input string) int {
	grid := utils.MakeGrid(input)

	parts := FindPartNumbers(grid)

	sum := 0

	for _, num := range parts {
		sum += num
	}

	return sum
}

func TestPartOne(t *testing.T) {
	testInput := `
467..114..
...*......
..35..633.
......#...
617*......
.......58.
..592.....
..+....755
...$.*..._
.664.598..
`

	fmt.Println(PartOne(testInput))
	input := utils.ReadInput(3)
	fmt.Println(PartOne(input))
}

func PartTwo(input string) int {
	grid := utils.MakeGrid(input)

	sum := 0

	for row := grid.MinY; row <= grid.MaxY; row++ {
		for col := grid.MinX; col <= grid.MaxX; col++ {
			point := utils.Point{X: col, Y: row}
			char := grid.Data[point]

			if char != '*' {
				continue
			}

			neighbors := point.Neighbors8()
			numbers := make(map[int]bool)

			for _, val := range neighbors {
				if !unicode.IsNumber(grid.Data[val]) {
					continue
				}
				num := ExtractNumberAt(grid, val)
				number, _ := strconv.Atoi(num)
				numbers[number] = true
			}

			if len(numbers) == 2 {
				ratio := 1
				for key := range numbers {
					ratio *= key
				}

				sum += ratio
			}

		}
	}

	return sum
}

func TestPartTwo(t *testing.T) {
	testInput := `
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
`

	fmt.Println(PartTwo(testInput))

	input := utils.ReadInput(3)
	fmt.Println(PartTwo(input))
}
