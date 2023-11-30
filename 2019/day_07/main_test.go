package day07

import (
	"advent-of-code-2019/intcode"
	"advent-of-code-2019/utils"
	"fmt"
	"testing"
)

func GenerateCombinations() [][]int {
	response := make([][]int, 0)

	for i := 0; i < 5; i++ {
		for j := 0; j < 5; j++ {
			if i == j {
				continue
			}
			for k := 0; k < 5; k++ {
				if i == k || j == k {
					continue
				}
				for l := 0; l < 5; l++ {
					if i == l || j == l || l == k {
						continue
					}
					for m := 0; m < 5; m++ {
						if m == i || m == j || m == k || m == l {
							continue
						}
						response = append(response, []int{i, j, k, l, m})
					}
				}
			}
		}
	}

	return response
}

func TestCombinations(t *testing.T) {
	if len(GenerateCombinations()) != 120 {
		t.Errorf("Expected 120 combos, got: %d", len(GenerateCombinations()))
	}
}

func RunAmplificationCircuit(program string, phaseSettings []int) int {
	input := 0
	phase := phaseSettings[0]
	phaseSettings = phaseSettings[1:]

	a := intcode.NewComputerFromString(program)
	a.Input <- phase
	a.Input <- input
	a.ExecuteIntcode()

	phase = phaseSettings[0]
	phaseSettings = phaseSettings[1:]
	input = <-a.Output
	b := intcode.NewComputerFromString(program)
	b.Input <- phase
	b.Input <- input
	b.ExecuteIntcode()

	phase = phaseSettings[0]
	phaseSettings = phaseSettings[1:]
	input = <-b.Output
	c := intcode.NewComputerFromString(program)
	c.Input <- phase
	c.Input <- input
	c.ExecuteIntcode()

	phase = phaseSettings[0]
	phaseSettings = phaseSettings[1:]
	input = <-c.Output
	d := intcode.NewComputerFromString(program)
	d.Input <- phase
	d.Input <- input
	d.ExecuteIntcode()

	phase = phaseSettings[0]
	// phaseSettings = phaseSettings[1:]
	input = <-d.Output
	e := intcode.NewComputerFromString(program)
	e.Input <- phase
	e.Input <- input
	e.ExecuteIntcode()

	return <-e.Output
}

func TestRunAmplificationCircuit(t *testing.T) {
	tests := []struct {
		program  string
		phases   []int
		expected int
	}{
		{
			program:  "3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0",
			phases:   []int{4, 3, 2, 1, 0},
			expected: 43210,
		},
		{
			program:  "3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0",
			phases:   []int{0, 1, 2, 3, 4},
			expected: 54321,
		},
		{
			program:  "3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0",
			phases:   []int{1, 0, 4, 3, 2},
			expected: 65210,
		},
	}

	for _, test := range tests {
		t.Run(test.program, func(t *testing.T) {
			got := RunAmplificationCircuit(test.program, test.phases)

			if got != test.expected {
				t.Errorf("Expected amplification circuit to return %d, got: %d", test.expected, got)
			}
		})
	}
}

func TestPartOne(t *testing.T) {
	combos := GenerateCombinations()

	program := utils.ReadInput(7)

	max := -1

	for _, phase := range combos {
		val := RunAmplificationCircuit(program, phase)

		if val > max {
			max = val
		}
	}

	fmt.Printf("Day 7 Part 1: %d\n", max)
}
