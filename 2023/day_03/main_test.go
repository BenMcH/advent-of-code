package day_03

import (
	"advent-of-code-2023/utils"
	"fmt"
	"testing"
	"unicode"
)

func ExtractNumberAt(grid utils.Grid, point utils.Point) int {
	for point.X > grid.MinX && unicode.IsDigit(grid.Data[point.Left()]) {
		point = point.Left()
	}

	num := int(grid.Data[point] - '0')

	for unicode.IsDigit(grid.Data[point.Right()]) {
		point = point.Right()
		num = num*10 + int(grid.Data[point]-'0')
	}

	return num
}

func FindPartNumbers(grid utils.Grid) []int {
	partNumbers := make([]int, 0)

	for row := grid.MinY; row <= grid.MaxY; row++ {
		num := 0
		isSurrounded := false
		for col := grid.MinX; col <= grid.MaxX; col++ {
			point := utils.Point{X: col, Y: row}

			if unicode.IsNumber(grid.Data[point]) {
				num = num*10 + int(grid.Data[point]-'0')
				neighbors := point.Neighbors8()

				for _, val := range neighbors {
					if rn, ok := grid.Data[val]; ok {
						isSurrounded = isSurrounded || (rn != '.' && !unicode.IsDigit(rn))
					}
				}
			} else {
				if num > 0 && isSurrounded {
					partNumbers = append(partNumbers, num)
				}

				num = 0
				isSurrounded = false
			}
		}

		if isSurrounded {
			partNumbers = append(partNumbers, num)
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

			if grid.Data[point] == '*' {
				numbers := make(map[int]bool)

				for _, val := range point.Neighbors8() {
					if unicode.IsNumber(grid.Data[val]) {
						numbers[ExtractNumberAt(grid, val)] = true
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
