package day12

import (
	"advent-of-code-2023/utils"
	"fmt"
	"strings"
	"testing"
)

type cacheKey struct {
	strLoc,
	numberLoc,
	groupLength int
}

const (
	OPERATIONAL = '.'
	DAMAGED     = '#'
	UNKNOWN     = '?'
)

func CountArrangements(input string) int {
	input, numStrs, _ := strings.Cut(input, " ")
	nums := utils.NumbersFromString(numStrs)
	cache := make(map[cacheKey]int)
	combos := CountCombos(input, 0, nums, 0, 0, cache)

	return combos
}

func CountCombos(springs string, springIndex int, damagedSpringGroupSizes []int, groupIndex int, currentGroupLength int, cache map[cacheKey]int) int {
	key := cacheKey{
		springIndex,
		groupIndex,
		currentGroupLength,
	}

	count := 0

	if len(springs) == springIndex {
		if (groupIndex == len(damagedSpringGroupSizes)-1 && damagedSpringGroupSizes[groupIndex] == currentGroupLength) || (len(damagedSpringGroupSizes) == groupIndex && currentGroupLength == 0) {
			count++
		}
	} else if sum, ok := cache[key]; ok {
		count = sum
	} else {
		curr := springs[springIndex]
		springIndex++

		if curr == UNKNOWN || curr == DAMAGED {
			count = count + CountCombos(springs, springIndex, damagedSpringGroupSizes, groupIndex, currentGroupLength+1, cache)
		}

		if curr == OPERATIONAL || curr == UNKNOWN {
			if currentGroupLength == 0 {
				count += CountCombos(springs, springIndex, damagedSpringGroupSizes, groupIndex, 0, cache)
			} else if groupIndex < len(damagedSpringGroupSizes) && damagedSpringGroupSizes[groupIndex] == currentGroupLength {
				count += CountCombos(springs, springIndex, damagedSpringGroupSizes, groupIndex+1, 0, cache)
			}
		}

		cache[key] = count
	}

	return count
}
func TestCountArrangements(t *testing.T) {
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
	lines := utils.Lines(utils.ReadInput(12))

	lines = utils.Map(lines, func(str string, i int) string {
		return expandLine(str)
	})

	arrs := utils.Map(lines, func(str string, i int) int {
		return CountArrangements(str)
	})

	fmt.Println(utils.SumIntArr(arrs))
}
