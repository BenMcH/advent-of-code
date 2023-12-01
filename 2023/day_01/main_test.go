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

	nums := make(map[string]int)

	nums["0"] = 0
	nums["1"] = 1
	nums["2"] = 2
	nums["3"] = 3
	nums["4"] = 4
	nums["5"] = 5
	nums["6"] = 6
	nums["7"] = 7
	nums["8"] = 8
	nums["9"] = 9

	matches := regex.FindAllString(input, -1)

	fmt.Println(matches)

	firstNum := matches[0]
	lastNum := matches[len(matches)-1]
	first := nums[firstNum]
	last := nums[lastNum]

	str := fmt.Sprintf("%d%d", first, last)

	val, _ := strconv.Atoi(str)

	return val
}

func Extract2(input string) int {
	first := 0
	last := 0

	for len(input) > 0 {
		fmt.Println(first, last, input)
		if val, _ := regexp.MatchString(`\d`, input[0:1]); val {
			if first == 0 {
				first, _ = strconv.Atoi(string(input[0]))
			}
			last, _ = strconv.Atoi(string(input[0]))
		}
		if strings.HasPrefix(input, "one") {
			if first == 0 {
				first = 1
			}
			last = 1
		} else if strings.HasPrefix(input, "two") {
			if first == 0 {
				first = 2
			}
			last = 2
		} else if strings.HasPrefix(input, "three") {
			if first == 0 {
				first = 3
			}
			last = 3
		} else if strings.HasPrefix(input, "four") {
			if first == 0 {
				first = 4
			}
			last = 4
		} else if strings.HasPrefix(input, "five") {
			if first == 0 {
				first = 5
			}
			last = 5
		} else if strings.HasPrefix(input, "six") {
			if first == 0 {
				first = 6
			}
			last = 6
		} else if strings.HasPrefix(input, "seven") {
			if first == 0 {
				first = 7
			}
			last = 7
		} else if strings.HasPrefix(input, "eight") {
			if first == 0 {
				first = 8
			}
			last = 8
		} else if strings.HasPrefix(input, "nine") {
			if first == 0 {
				first = 9
			}
			last = 9
		}

		input = input[1:]
	}

	return first*10 + last
}

func TestPartOne(t *testing.T) {
	// testInput := "1abc2\npqr3stu8vwx\na1b2c3d4e5f\ntreb7uchet"
	input := utils.ReadInput(1)

	lines := strings.Split(input, "\n")

	nums := make([]int, len(lines))

	sum := 0
	for idx, str := range lines {
		nums[idx] = ExtractNumbers(str)
		sum += nums[idx]
	}

	fmt.Println(sum)
}

func TestAdvancedNumbers(t *testing.T) {
	// input := "two1nine\neightwothree\nabcone2threexyz\nxtwone3four\n4nineeightseven2\nzoneight234\n7pqrstsixteen"
	input := utils.ReadInput(1)
	lines := strings.Split(input, "\n")

	nums := make([]int, len(lines))

	sum := 0
	for idx, str := range lines {
		nums[idx] = Extract2(str)
		fmt.Println(nums[idx])
		sum += nums[idx]
	}

	fmt.Println(sum)
}
