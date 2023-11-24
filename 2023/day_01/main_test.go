package day_01

import (
	"advent-of-code-2023/utils"
	"testing"
)

func PartOne(input string) int {
	return len(input)
}

func TestTestFunc(t *testing.T) {
	input := utils.ReadFile("./input.txt")

	got := PartOne(input)

	if got != 654 {
		t.Errorf("Got: %d, expected: 3363760", got)
	}
}

func PartTwo(input string) int {
	return len(input)
}

func TestPartTwo(t *testing.T) {
	input := utils.ReadFile("./input.txt")

	got := PartTwo(input)

	if got != 5042767 {
		t.Errorf("Got: %d, expected: \"Hello World!\"", got)
	}
	t.Logf("Day 1 part 2: %d", got)
}
