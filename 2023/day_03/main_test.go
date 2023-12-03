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

func IsSymbol(input rune) bool {
	// symbols := "!@#$%^&*()/\\+=-"
	sym := input != '.' && !unicode.IsDigit(input) && input != '\n'
	// if sym && !strings.ContainsRune(symbols, input) {
	// 	fmt.Printf("Symbol %v\n", strconv.QuoteRune(input))
	// }
	return sym
}

func FindPartNumbers(board [][]rune) []int {
	partNumbers := make([]int, 0)

	for row := 0; row < len(board); row++ {
		line := board[row]
		up := row > 0
		down := row < len(board)-1
		for col := 0; col < len(line); col++ {
			if row == 7 && col == 7 {
				fmt.Println("lastrow")
			}
			char := line[col]
			left := col > 0
			right := col < len(board[row])-1
			if row == 0 && col == 2 {
				fmt.Println(string(char), up, down, left, right)
			}
			isSurrounded := false

			if !unicode.IsNumber(char) {
				continue
			}
			if up {
				if IsSymbol(board[row-1][col]) {
					isSurrounded = true
				} else if left && IsSymbol(board[row-1][col-1]) {
					isSurrounded = true
				} else if right && IsSymbol(board[row-1][col+1]) {
					isSurrounded = true
				}
			}
			if left && IsSymbol(line[col-1]) {
				isSurrounded = true
			}
			if right && IsSymbol(line[col+1]) {
				isSurrounded = true
			}
			if down {
				if IsSymbol(board[row+1][col]) {
					isSurrounded = true
				} else if left && IsSymbol(board[row+1][col-1]) {
					isSurrounded = true
				} else if right && IsSymbol(board[row+1][col+1]) {
					isSurrounded = true
				}
			}

			if isSurrounded {
				numberStr := ExtractNumberAt(board, col, row)
				number, _ := strconv.Atoi(numberStr)

				partNumbers = append(partNumbers, number)

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
	fmt.Println(strconv.Quote(lines[0]))
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
