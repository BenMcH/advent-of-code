package day_05

import (
	"advent-of-code-2019/intcode"
	"advent-of-code-2019/utils"
	"fmt"
	"testing"
)

func TestInputOutput(t *testing.T) {
	_, outputs := intcode.ExecuteIntcodeFromString("3,0,4,0,99", []int{1})

	if outputs[0] != 1 {
		t.Errorf("Expected 1; Got: %d", outputs[0])
	}
}

func PartOne(lower, upper int) int {
	return 0
}

func TestImmediateMultiplication(t *testing.T) {
	program, output := intcode.ExecuteIntcodeFromString("1002,4,3,4,33", []int{1})

	if program[4] != 99 {
		t.Errorf("Expected program[4] to be 99. Got %d", program[4])
	}

	if len(output) != 0 {
		t.Errorf("Did not expect any output. Got %v", output)
	}

	program, output = intcode.ExecuteIntcodeFromString("102,33,4,4,3", []int{1})

	if program[4] != 99 {
		t.Errorf("Expected program[4] to be 99. Got %d", program[4])
	}

	if len(output) != 0 {
		t.Errorf("Did not expect any output. Got %v", output)
	}
}
func TestPartOne(t *testing.T) {
	input := utils.ReadInput(5)

	_, output := intcode.ExecuteIntcodeFromString(input, []int{1})

	for i := 0; i < len(output)-1; i++ {
		if output[i] != 0 {
			fmt.Println(output)
			t.Errorf("Expected test to pass; Got: %d at index %d", output[i], i)
		}
	}

	fmt.Printf("Day 5 Part 1: %v\n", output[len(output)-1])
}

func TestEquals(t *testing.T) {
	program := "3,9,8,9,10,9,4,9,99,-1,8"
	_, output := intcode.ExecuteIntcodeFromString(program, []int{8})

	if len(output) != 1 || output[0] != 1 {
		t.Errorf("Using position mode, consider whether the input is equal to 8; output 1; Len: %d, result: %v", len(output), output)
	}

	_, output = intcode.ExecuteIntcodeFromString(program, []int{7})

	if len(output) != 1 || output[0] != 0 {
		t.Errorf("Using position mode, consider whether the input is not equal to 8; output 0; Len: %d, result: %v", len(output), output)
	}

	program = "3,3,1108,-1,8,3,4,3,99"
	_, output = intcode.ExecuteIntcodeFromString(program, []int{8})

	if len(output) != 1 || output[0] != 1 {
		t.Errorf("Using immediate mode, consider whether the input is equal to 8; output 1; Len: %d, result: %v", len(output), output)
	}

	_, output = intcode.ExecuteIntcodeFromString(program, []int{7})

	if len(output) != 1 || output[0] != 0 {
		t.Errorf("Using immediate mode, consider whether the input is not equal to 8; output 0; Len: %d, result: %v", len(output), output)
	}
}

func TestLessThan(t *testing.T) {
	program := "3,9,7,9,10,9,4,9,99,-1,8"
	_, output := intcode.ExecuteIntcodeFromString(program, []int{7})

	if len(output) != 1 || output[0] != 1 {
		t.Errorf("Using position mode, consider whether the input is less than 8; output 1; Len: %d, result: %v", len(output), output)
	}

	_, output = intcode.ExecuteIntcodeFromString(program, []int{9})

	if len(output) != 1 || output[0] != 0 {
		t.Errorf("Using position mode, consider whether the input is not less than 8; output 0; Len: %d, result: %v", len(output), output)
	}

	program = "3,3,1107,-1,8,3,4,3,99"

	_, output = intcode.ExecuteIntcodeFromString(program, []int{7})

	if len(output) != 1 || output[0] != 1 {
		t.Errorf("Using immediate mode, consider whether the input is less than 8; output 1; Len: %d, result: %v", len(output), output)
	}

	_, output = intcode.ExecuteIntcodeFromString(program, []int{8})

	if len(output) != 1 || output[0] != 0 {
		t.Errorf("Using immediate mode, consider whether the input is not less than 8; output 0; Len: %d, result: %v", len(output), output)
	}
}

func TestJumps(t *testing.T) {
	program := "3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9"

	_, output := intcode.ExecuteIntcodeFromString(program, []int{0})

	if len(output) != 1 || output[0] != 0 {
		t.Errorf("output 0 if the input was zero; Len: %d, result: %v", len(output), output)
	}

	_, output = intcode.ExecuteIntcodeFromString(program, []int{4})

	if len(output) != 1 || output[0] != 1 {
		t.Errorf("output 1 if the input was not zero; Len: %d, result: %v", len(output), output)
	}

	program = "3,3,1105,-1,9,1101,0,0,12,4,12,99,1"

	_, output = intcode.ExecuteIntcodeFromString(program, []int{0})

	if len(output) != 1 || output[0] != 0 {
		t.Errorf("output 0 if the input was zero; Len: %d, result: %v", len(output), output)
	}

	_, output = intcode.ExecuteIntcodeFromString(program, []int{4})

	if len(output) != 1 || output[0] != 1 {
		t.Errorf("output 1 if the input was not zero; Len: %d, result: %v", len(output), output)
	}
}

func TestPartTwo(t *testing.T) {
	input := utils.ReadInput(5)

	_, output := intcode.ExecuteIntcodeFromString(input, []int{5})

	if len(output) != 1 {
		t.Errorf("Expected a single output. Got %d, %v", len(output), output)
	}

	fmt.Printf("Day 5 part 2: %d", output[0])

}
