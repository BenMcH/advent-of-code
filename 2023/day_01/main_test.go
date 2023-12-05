package day_01

import (
	"advent-of-code-2023/utils"
	"fmt"
	"regexp"
	"strconv"
	"strings"
	"testing"
)

func ExtractNumbers(input string) int {
	regex := regexp.MustCompile(`\d`)
	matches := regex.FindAllString(input, -1)

	firstNum := matches[0]
	lastNum := matches[len(matches)-1]
	first, _ := strconv.Atoi(firstNum)
	last, _ := strconv.Atoi(lastNum)

	return first*10 + last
}

func TestPartOne(t *testing.T) {
	lines := utils.Lines(utils.ReadInput(1))

	sum := 0
	for _, str := range lines {
		sum += ExtractNumbers(str)
	}

	fmt.Println(sum)
}

func TestAdvancedNumbers(t *testing.T) {
	input := utils.ReadInput(1)
	input = strings.ReplaceAll(input, "eight", "8t")
	input = strings.ReplaceAll(input, "two", "2o")
	input = strings.ReplaceAll(input, "one", "1")
	input = strings.ReplaceAll(input, "three", "3")
	input = strings.ReplaceAll(input, "four", "4")
	input = strings.ReplaceAll(input, "five", "5")
	input = strings.ReplaceAll(input, "six", "6")
	input = strings.ReplaceAll(input, "seven", "7")
	input = strings.ReplaceAll(input, "nine", "9")
	lines := utils.Lines(input)
	arr := utils.Map(lines, func(str string) int {
		return ExtractNumbers(str)
	})

	fmt.Println(utils.SumIntArr(arr))
}
