package day_05

import (
	"advent-of-code-2019/intcode"
	"advent-of-code-2019/utils"
	"fmt"
	"testing"
)

func TestInputOutput(t *testing.T) {
	computer := intcode.NewComputerFromString("3,0,4,0,99")
	computer.Input <- 1

	computer.ExecuteIntcode()

	output := <-computer.Output
	if output != 1 {
		t.Errorf("Expected 1; Got: %d", output)
	}
}

func TestImmediateMultiplication(t *testing.T) {
	tests := []string{
		"1002,4,3,4,33",
		"102,33,4,4,3",
	}

	for _, test := range tests {
		t.Run(test, func(t *testing.T) {
			computer := intcode.NewComputerFromString(test)
			computer.Input <- 1
			computer.ExecuteIntcode()

			if computer.Program[4] != 99 {
				t.Errorf("Expected computer.Program[4] to be 99. Got %d", computer.Program[4])
			}

			if len(computer.Output) != 0 {
				t.Errorf("Did not expect any computer.Output. Got %v", computer.Output)
			}
		})
	}
}
func TestPartOne(t *testing.T) {
	input := utils.ReadInput(5)

	computer := intcode.NewComputerFromString(input)
	computer.Input <- 1
	computer.ExecuteIntcode()

	output := make([]int, 0)

	for val := range computer.Output {
		output = append(output, val)
	}

	for i := 0; i < len(output)-1; i++ {
		if output[i] != 0 {
			t.Errorf("Expected tests to pass; Got %d", output[i])
		}
	}

	fmt.Printf("Day 5 Part 1: %v\n", output[len(output)-1])
}

func TestComparisons(t *testing.T) {
	tests := []struct {
		program     string
		input       int
		output      int
		description string
	}{
		{
			program:     "3,9,8,9,10,9,4,9,99,-1,8",
			input:       8,
			output:      1,
			description: "Using position mode, consider whether the input is equal to 8",
		},
		{
			program:     "3,9,8,9,10,9,4,9,99,-1,8",
			input:       7,
			output:      0,
			description: "Using position mode, consider whether the input is equal to 8",
		},
		{
			program:     "3,3,1108,-1,8,3,4,3,99",
			input:       8,
			output:      1,
			description: "Using immediate mode, consider whether the input is equal to 8",
		},
		{
			program:     "3,3,1108,-1,8,3,4,3,99",
			input:       7,
			output:      0,
			description: "Using immediate mode, consider whether the input is equal to 8",
		},
		{
			program:     "3,9,7,9,10,9,4,9,99,-1,8",
			input:       7,
			output:      1,
			description: "Using position mode, consider whether the input is less than 8",
		},
		{
			program:     "3,9,7,9,10,9,4,9,99,-1,8",
			input:       9,
			output:      0,
			description: "Using position mode, consider whether the input is less than 8",
		},
		{
			program:     "3,3,1107,-1,8,3,4,3,99",
			input:       7,
			output:      1,
			description: "Using immediate mode, consider whether the input is less than 8",
		},
		{
			program:     "3,3,1107,-1,8,3,4,3,99",
			input:       8,
			output:      0,
			description: "Using immediate mode, consider whether the input is less than 8",
		},
		{
			program:     "3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9",
			input:       0,
			output:      0,
			description: "Jump: output 0 if the input was zero",
		},
		{
			program:     "3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9",
			input:       2,
			output:      1,
			description: "Jump: output 1 if the input was not zero",
		},
		{
			program:     "3,3,1105,-1,9,1101,0,0,12,4,12,99,1",
			input:       0,
			output:      0,
			description: "Jump: output 0 if the input was zero",
		},
		{
			program:     "3,3,1105,-1,9,1101,0,0,12,4,12,99,1",
			input:       2,
			output:      1,
			description: "Jump: output 1 if the input was not zero",
		},
	}

	for _, test := range tests {
		t.Run(test.description, func(t *testing.T) {
			computer := intcode.NewComputerFromString(test.program)
			computer.Input <- test.input

			computer.ExecuteIntcode()

			got := <-computer.Output

			if got != test.output {
				t.Errorf("Expected %d, got %d", test.output, got)
			}
		})
	}
}

func TestPartTwo(t *testing.T) {
	input := utils.ReadInput(5)

	computer := intcode.NewComputerFromString(input)
	computer.Input <- 5
	computer.ExecuteIntcode()

	output := <-computer.Output

	fmt.Printf("Day 5 part 2: %d", output)

}
