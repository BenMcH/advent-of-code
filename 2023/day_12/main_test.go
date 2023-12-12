package day12

import (
	"advent-of-code-2023/utils"
	"fmt"
	"slices"
	"strings"
	"testing"
)

const (
	OPERATIONAL = '.'
	DAMAGED     = '#'
	UNKNOWN     = '?'
)

func CountArrangements(input string) int {
	sections := strings.Split(input, " ")
	row := []rune(sections[0])
	nums := utils.NumbersFromString(sections[1])

	combos := MakeCombinations(row, nums)
	// combos = utils.Filter(combos, func(r []rune, i int) bool { return isValid(r, nums) })

	return combos
}

func MakeCombinations(input []rune, expectations []int) int {
	count := 0
	if slices.Contains(input, UNKNOWN) {
		if !tentativelyValid(input, expectations) {
			return 0
		}
		unknownIndex := slices.Index(input, UNKNOWN)
		input[unknownIndex] = OPERATIONAL
		count = count + MakeCombinations(input, expectations)
		input[unknownIndex] = DAMAGED
		count = count + MakeCombinations(input, expectations)
		input[unknownIndex] = UNKNOWN
	} else {
		if isValid(input, expectations) {
			count++
		}
	}

	return count
}

func isValid(input []rune, nums []int) bool {
	count := 0
	numDamaged := utils.Count(input, func(r rune) bool { return r == DAMAGED })
	if numDamaged != utils.SumIntArr(nums) {
		return false
	}
	for _, rn := range input {
		if rn == OPERATIONAL {
			if count > 0 {
				nums = nums[1:]
			}
			count = 0
		} else {
			count++
			if len(nums) == 0 || count > nums[0] {
				return false
			}
		}
	}
	if len(nums) > 1 || (len(nums) == 1 && nums[0] != count) {
		return false
	}
	return true
}

func tentativelyValid(input []rune, nums []int) bool {
	count := 0
	for _, rn := range input {
		if rn == OPERATIONAL {
			if count > 0 {
				if len(nums) == 0 || nums[0] > count {
					return false
				}
				nums = nums[1:]
			}
			count = 0
		} else if rn == DAMAGED {
			count++
		} else {
			return true
		}
	}
	return true
}

func TestCountArrangements(t *testing.T) {
	fmt.Println(isValid([]rune(".###.##.#..."), []int{3, 2, 1}))
	tests := []struct {
		input       string
		expectation int
	}{
		{"?###???????? 3,2,1", 10},
	}

	for _, test := range tests {
		t.Run(test.input, func(t *testing.T) {
			if CountArrangements(test.input) != test.expectation {
				t.Error("Expected", test.expectation, "Got", CountArrangements(test.input))
			}
		})
	}
}

func TestPartOne(t *testing.T) {
	lines := utils.Lines(utils.ReadInput(12))

	arrs := utils.Map(lines, func(str string, i int) int { return CountArrangements(str) })

	fmt.Println(utils.SumIntArr(arrs))
}

func expandLine(str string) string {
	parts := strings.Split(str, " ")
	newStr := ""

	nums := strings.Split(parts[1], ",")
	nNums := make([]string, 0)

	for i := 0; i < 5; i++ {
		newStr = newStr + parts[0] + "?"
		nNums = append(nNums, nums...)
	}

	newStr = newStr[0 : len(newStr)-1]
	newStr = fmt.Sprintf("%s %s", newStr, strings.Join(nNums, ","))

	return newStr

}

func TestPartTwo(t *testing.T) {
	fmt.Println(CountArrangements(expandLine("????.######..#####. 1,6,5")))
	lines := utils.Lines(utils.ReadInput(12))

	lines = utils.Map(lines, func(str string, i int) string {
		return expandLine(str)
	})

	arrs := utils.Map(lines, func(str string, i int) int {
		fmt.Println(i)
		return CountArrangements(str)
	})

	fmt.Println(utils.SumIntArr(arrs))
}
