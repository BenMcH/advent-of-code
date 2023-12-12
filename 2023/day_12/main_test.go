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

	combos := MakeCombinations(row)
	combos = utils.Filter(combos, func(r []rune, i int) bool { return isValid(r, nums) })

	return len(combos)
}

func MakeCombinations(input []rune) [][]rune {
	val := make([][]rune, 0)

	if slices.Contains(input, UNKNOWN) {
		newInput := make([]rune, len(input))
		copy(newInput, input)

		unknownIndex := slices.Index(newInput, UNKNOWN)
		newInput[unknownIndex] = OPERATIONAL
		val = append(val, MakeCombinations(newInput)...)
		newInput = make([]rune, len(input))
		copy(newInput, input)
		newInput[unknownIndex] = DAMAGED
		val = append(val, MakeCombinations(newInput)...)
	} else {
		val = append(val, input)
	}

	return val
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
				if len(nums) == 0 || nums[0] != count {
					return false
				}
				nums = nums[1:]
			}
			count = 0
		} else {
			count++
		}
	}
	if len(nums) > 1 || (len(nums) == 1 && nums[0] != count) {
		return false
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
