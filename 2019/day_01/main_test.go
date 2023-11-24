package day_01

import (
	"advent-of-code-2019/utils"
	"testing"
)

func TestPartOne(t *testing.T) {
	input := "100756"

	got := PartOne(input)

	if got != 33583 {
		t.Errorf("Got: %d, expected: 3363760", got)
		return
	}

	input = utils.ReadFile("./input.txt")

	t.Logf("Day 1 Part 1: %d", PartOne(input))
}

func TestPartTwo(t *testing.T) {
	input := "100756"
	got := PartTwo(input)

	if got != 50346 {
		t.Errorf("Got: %d, expected: \"Hello World!\"", got)
		return
	}

	input = utils.ReadFile("./input.txt")

	t.Logf("Day 1 part 2: %d", PartTwo(input))
}
