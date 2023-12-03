package day_03

import (
	"advent-of-code-2023/utils"
	"fmt"
	"strconv"
	"strings"
	"testing"
	"unicode"
)

func ExtractNumberAt(board [][]rune, x, y int) string {
	startX := x
	line := board[y]

	for startX > 0 && unicode.IsDigit(line[startX-1]) {
		startX -= 1
	}

	endX := x

	for endX < len(line)-1 && unicode.IsDigit(line[endX+1]) {
		endX += 1
	}

	runes := board[y][startX : endX+1]

	return string(runes)
}

type Element struct {
	value    rune
	row, col int
}

func SurroundingElements(board [][]rune, col, row int) []Element {
	arr := make([]Element, 0)
	up := row > 0
	down := row < len(board)-1
	left := col > 0
	right := col < len(board[row])-1
	if up {
		arr = append(arr, Element{board[row-1][col], row - 1, col})
		if left {
			arr = append(arr, Element{board[row-1][col-1], row - 1, col - 1})
		}
		if right {
			arr = append(arr, Element{board[row-1][col+1], row - 1, col + 1})
		}
	}
	if left {
		arr = append(arr, Element{board[row][col-1], row, col - 1})
	}
	if right {
		arr = append(arr, Element{board[row][col+1], row, col + 1})
	}
	if down {
		arr = append(arr, Element{board[row+1][col], row + 1, col})
		if left {
			arr = append(arr, Element{board[row+1][col-1], row + 1, col - 1})
		}
		if right {
			arr = append(arr, Element{board[row+1][col+1], row + 1, col + 1})
		}
	}

	return arr
}

func IsSymbol(input rune) bool {
	sym := input != '.' && !unicode.IsDigit(input) && input != '\n'
	return sym
}

type PartNumber struct {
	number   int
	row, col int
}

func FindPartNumbers(board [][]rune) []PartNumber {
	partNumbers := make([]PartNumber, 0)

	for row := 0; row < len(board); row++ {
		line := board[row]
		for col := 0; col < len(line); col++ {
			char := line[col]
			isSurrounded := false

			if !unicode.IsNumber(char) {
				continue
			}

			surrounding := SurroundingElements(board, col, row)

			for _, val := range surrounding {
				if IsSymbol(val.value) {
					isSurrounded = true
				}
			}

			if isSurrounded {
				numberStr := ExtractNumberAt(board, col, row)
				number, _ := strconv.Atoi(numberStr)

				partNumbers = append(partNumbers, PartNumber{number, row, col})

				for col < len(line)-1 && unicode.IsDigit(line[col+1]) {
					col += 1
				}
			}
		}
	}

	return partNumbers
}

func PartOne(input string) int {
	lines := strings.Split(strings.Trim(input, "\n"), "\n")
	characters := make([][]rune, len(lines))

	for row, line := range lines {
		characters[row] = make([]rune, len(line))
		for col, char := range line {
			characters[row][col] = char
		}
	}

	parts := FindPartNumbers(characters)

	sum := 0

	for _, num := range parts {
		sum += num.number
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
	lines := strings.Split(strings.Trim(input, "\n"), "\n")
	characters := make([][]rune, len(lines))

	for row, line := range lines {
		characters[row] = make([]rune, len(line))
		for col, char := range line {
			characters[row][col] = char
		}
	}

	sum := 0

	for row, line := range characters {
		for col, char := range line {
			if char != '*' {
				continue
			}

			surrounding := SurroundingElements(characters, col, row)

			numbers := make(map[int]bool)

			for _, val := range surrounding {
				if !unicode.IsNumber(val.value) {
					continue
				}
				num := ExtractNumberAt(characters, val.col, val.row)
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
