package day_04

import (
	"advent-of-code-2019/utils"
	"fmt"
	"strings"
	"testing"
)

func ParseInput(input string) (int, int) {
	inputs := strings.Split(strings.Split(input, "\n")[0], "-")

	ints, _ := utils.StringsToInts(inputs)

	return ints[0], ints[1]
}

func MeetsPartOneCriteria(num int) bool {
	runes := []rune(fmt.Sprint(num))

	if len(runes) != 6 {
		return false
	}

	doubles := false
	decreasing := false

	for i := 0; i < len(runes)-1; i++ {
		if runes[i] > runes[i+1] {
			decreasing = true
		}

		if runes[i] == runes[i+1] {
			doubles = true
		}
	}

	return !decreasing && doubles
}

func TestMeetsPartOneCriteria(t *testing.T) {
	if MeetsPartOneCriteria(1111111) {
		t.Error("Expected 1111111 not to be valid (Longer than 6 chars)")
	}

	if MeetsPartOneCriteria(11111) {
		t.Error("Expected 11111 not to be valid (Shorter than 6 chars)")
	}

	if !MeetsPartOneCriteria(111111) {
		t.Error("Expected 111111 to be valid")
	}

	if MeetsPartOneCriteria(223450) {
		t.Error("Expected 223450 to fail (50 decrease)")
	}

	if MeetsPartOneCriteria(123789) {
		t.Error("Expected 123789 to fail (No doubles)")
	}
}

func PartOne(lower, upper int) int {
	count := 0
	for i := lower; i <= upper; i++ {
		if MeetsPartOneCriteria(i) {
			count++
		}
	}
	return count
}

func TestPartOne(t *testing.T) {
	input := utils.ReadInput(4)

	min, max := ParseInput(input)

	fmt.Printf("Day 4 Part 1: %d\n", PartOne(min, max))
}

func HasExactDouble(num int) bool {
	count := make(map[rune]int)

	for _, r := range fmt.Sprint(num) {
		count[r] += 1
	}

	for _, v := range count {
		if v == 2 {
			return true
		}
	}

	return false
}

func TestHasExactDouble(t *testing.T) {
	if HasExactDouble(123456) {
		t.Errorf("123456 contains no doubles")
	}

	if HasExactDouble(111456) {
		t.Errorf("111456 contains a triple 1 but no doubles")
	}

	if !HasExactDouble(111446) {
		t.Errorf("111446 contains a double 4 which counts")
	}
}

func PartTwo(lower, upper int) int {
	count := 0
	for i := lower; i <= upper; i++ {
		if MeetsPartOneCriteria(i) && HasExactDouble(i) {
			count++
		}
	}
	return count
}

func TestPartTwo(t *testing.T) {
	input := utils.ReadInput(4)

	min, max := ParseInput(input)

	fmt.Printf("Day 4 Part 2: %d\n", PartTwo(min, max))
}
