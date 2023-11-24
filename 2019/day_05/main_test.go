package day_05

import (
	"advent-of-code-2019/intcode"
	"testing"
)

func TestInputOutput(t *testing.T) {
	_, outputs := intcode.ExecuteIntcodeFromString("3,0,4,0,99")

	if outputs[0] != 1 {
		t.Errorf("Expected 1; Got: %d", outputs[0])
	}
}

func PartOne(lower, upper int) int {
	return 0
}

// func TestImmediateMultiplication(t *testing.T) {
// 	intcode.ExecuteIntcodeFromString("1002,4,3,4,33")
// 	fmt.Println("Here")
// 	intcode.ExecuteIntcodeFromString("102,3,4,4,33")
// }
// func TestPartOne(t *testing.T) {
// 	input := utils.ReadInput(5)

// 	_, output := intcode.ExecuteIntcodeFromString(input)

// 	for i := 0; i < len(output)-1; i++ {
// 		if output[i] != 0 {
// 			t.Errorf("Expected test to pass; Got: %d at index %d", output[i], i)
// 		}
// 	}

// 	// min, max := ParseInput(input)

// 	fmt.Printf("Day 5 Part 1: %v\n", output)
// }

func PartTwo(lower, upper int) int {
	count := 0
	return count
}

func TestPartTwo(t *testing.T) {
	// input := utils.ReadInput(5)

	// fmt.Printf("Day 4 Part 2: %d\n", PartTwo(1, 0))
}
