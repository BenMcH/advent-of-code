package day_06

import (
	"advent-of-code-2019/utils"
	"fmt"
	"strings"
	"testing"
)

func ParseOrbits(input string) map[string]string {
	lines := strings.Split(strings.Trim(input, "\n"), "\n")

	orbits := make(map[string]string)

	for _, line := range lines {
		entrs := strings.Split(line, ")")

		orbits[entrs[1]] = entrs[0]
	}

	return orbits
}

func CountRecursive(orbits map[string]string, key string) int {
	if key == "COM" {
		return 0
	}

	return 1 + CountRecursive(orbits, orbits[key])
}

func CountOrbits(orbits map[string]string) (count int) {
	count = 0

	for key := range orbits {
		if key == "COM" {
			continue
		}

		count += CountRecursive(orbits, key)
	}

	return
}

func TestOrbitParse(t *testing.T) {
	input := "COM)B\nB)C\nC)D"

	orbits := ParseOrbits(input)

	if len(orbits) != 3 {
		t.Errorf("Expected 3 orbits. Got %d", len(orbits))
	}

	if orbits["B"] != "COM" {
		t.Errorf("Expected B to orbit COM, got %s", orbits["B"])
	}

	if orbits["C"] != "B" {
		t.Errorf("Expected C to orbit B, got %s", orbits["C"])
	}

	if orbits["D"] != "C" {
		t.Errorf("Expected D to orbit C, got %s", orbits["D"])
	}
}

func TestCountOrbits(t *testing.T) {
	input := "COM)B\nB)C\nC)D\nD)E\nE)F\nB)G\nG)H\nD)I\nE)J\nJ)K\nK)L\n"
	orbits := ParseOrbits(input)

	count := CountOrbits(orbits)

	if count != 42 {
		t.Errorf("Expected 42 total orbits; Got %d", count)
	}
}

func TestPartOne(t *testing.T) {
	input := utils.ReadInput(6)

	orbits := ParseOrbits(input)

	count := CountOrbits(orbits)

	fmt.Printf("Day 6 Part 1: %d\n", count)
}

func DistanceBetween(orbits map[string]string, a, b string) int {

	if a == b {
		return 0
	}

	aDist := CountRecursive(orbits, a)
	bDist := CountRecursive(orbits, b)

	if aDist > bDist {
		return 1 + DistanceBetween(orbits, orbits[a], b)
	} else {
		return 1 + DistanceBetween(orbits, a, orbits[b])
	}
}

func PartTwo(input string) int {
	orbits := ParseOrbits(input)

	distance := DistanceBetween(orbits, orbits["YOU"], orbits["SAN"])

	return distance
}

func TestPartTwo(t *testing.T) {
	input := "COM)B\nB)C\nC)D\nD)E\nE)F\nB)G\nG)H\nD)I\nE)J\nJ)K\nK)L\nK)YOU\nI)SAN"

	distance := PartTwo(input)

	if distance != 4 {
		t.Errorf("Expected SAN to be 4 orbits away from YOU, got %d", distance)
	} else {
		input = utils.ReadInput(6)
		fmt.Printf("Day 6 part 2: %d\n", PartTwo(input))
	}
}
