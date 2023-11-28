package day_05

import (
	"advent-of-code-2019/intcode"
	"advent-of-code-2019/utils"
	"fmt"
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

func TestImmediateMultiplication(t *testing.T) {
	program, output := intcode.ExecuteIntcodeFromString("1002,4,3,4,33")

	if program[4] != 99 {
		t.Errorf("Expected program[4] to be 99. Got %d", program[4])
	}

	if len(output) != 0 {
		t.Errorf("Did not expect any output. Got %v", output)
	}
	
	program, output = intcode.ExecuteIntcodeFromString("102,33,4,4,3")

	if program[4] != 99 {
		t.Errorf("Expected program[4] to be 99. Got %d", program[4])
	}

	if len(output) != 0 {
		t.Errorf("Did not expect any output. Got %v", output)
	}
}
func TestPartOne(t *testing.T) {
	input := utils.ReadInput(5)

	_, output := intcode.ExecuteIntcodeFromString(input)

	for i := 0; i < len(output)-1; i++ {
		if output[i] != 0 {
			fmt.Println(output)
			t.Errorf("Expected test to pass; Got: %d at index %d", output[i], i)
		}
	}

	// min, max := ParseInput(input)

	fmt.Printf("Day 5 Part 1: %v\n", output[len(output)-1])
}

// func PartTwo(lower, upper int) int {
// 	count := 0
// 	return count
// }

// func TestPartTwo(t *testing.T) {
// 	// input := utils.ReadInput(5)

// 	// fmt.Printf("Day 4 Part 2: %d\n", PartTwo(1, 0))
// }
