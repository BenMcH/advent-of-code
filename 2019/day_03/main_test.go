package day_03

import (
	"advent-of-code-2019/utils"
	"testing"
)

func TestPartOne(t *testing.T) {
	got := PartOne("R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83")

	if got != 159 {
		t.Errorf("Got: %d, expected: 159", got)
		return
	}

	input := utils.ReadFile("./input.txt")

	answer := PartOne(input)

	t.Logf("Day 3 Part 1: %d", answer)
}

func TestPartTwo(t *testing.T) {
	got := PartTwo("R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83")

	if got != 610 {
		t.Errorf("Got: %d, expected: 610", got)
		return
	}

	input := utils.ReadFile("./input.txt")

	answer := PartTwo(input)

	t.Logf("Day 3 Part 2: %d", answer)
}
