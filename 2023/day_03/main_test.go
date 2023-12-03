package day_03

import (
	"advent-of-code-2023/utils"
	"fmt"
	"strconv"
	"testing"
	"unicode"
)

func ExtractNumberAt(grid utils.Grid, point utils.Point) int {
	point = utils.Point{X: point.X, Y: point.Y}

	for point.X > grid.MinX && unicode.IsDigit(grid.Data[point.Left()]) {
		point = point.Left()
	}

	runes := []rune{grid.Data[point]}

	for unicode.IsDigit(grid.Data[point.Right()]) {
		point = point.Right()
		runes = append(runes, grid.Data[point])
	}

	num, _ := strconv.Atoi(string(runes))

	return num
}

func IsSymbol(input rune) bool {
	return input != '.' && !unicode.IsDigit(input)
}

func FindPartNumbers(grid utils.Grid) []int {
	partNumbers := make([]int, 0)

	for row := grid.MinY; row <= grid.MaxY; row++ {
		for col := grid.MinX; col <= grid.MaxX; col++ {
			point := utils.Point{X: col, Y: row}
			isSurrounded := false

			if unicode.IsNumber(grid.Data[point]) {
				neighbors := point.Neighbors8()

				for _, val := range neighbors {
					if rn, ok := grid.Data[val]; ok {
						isSurrounded = isSurrounded || IsSymbol(rn)
					}
				}
			}

			if isSurrounded {
				number := ExtractNumberAt(grid, point)

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

			if char == '*' {

				neighbors := point.Neighbors8()
				numbers := make(map[int]bool)

				for _, val := range neighbors {
					if unicode.IsNumber(grid.Data[val]) {
						number := ExtractNumberAt(grid, val)
						numbers[number] = true
					}
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
