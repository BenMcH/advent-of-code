package day24

import (
	"advent-of-code-2023/utils"
	"fmt"
	"os"
	"os/exec"
	"testing"
)

const TEST_INPUT = `19, 13, 30 @ -2,  1, -2
18, 19, 22 @ -1, -1, -2
20, 25, 34 @ -2, -2, -4
12, 31, 28 @ -1, -2, -1
20, 19, 15 @  1, -5, -3
`

type Hailstone struct {
	x, y, z, px, py, pz float64
}

type Vec2 struct {
	x, y float64
}

func (h Hailstone) m() float64 {
	return h.py / h.px
}

func (h Hailstone) b() float64 {
	// y = mx + b
	// h.y = h.m() * h.x + b
	// y - mx = b
	// h.y - (h.m() * h.x) = b

	return h.y - (h.m() * h.x)
}

func (h Hailstone) intersection2d(h2 Hailstone) Vec2 {
	// ax+c=bx+d

	a := h.m()
	c := h.b()

	b := h2.m()
	d := h2.b()

	// x = (d-c)/(a-b)

	x := (d - c) / (a - b)

	// y = mx + b

	y := h.m()*x + h.b()

	return Vec2{
		x: x,
		y: y,
	}
}

func (h Hailstone) isInPast(v Vec2) bool {
	// Diff between intersection and 0 point
	x := v.x - h.x
	y := v.y - h.y

	// Calculate the steps required to cover dist
	x /= h.px
	y /= h.py

	// return whether either x or y required negative steps
	return x < 0 || y < 0
}

func parseHailstones(input string) []Hailstone {
	hailstones := make([]Hailstone, 0)

	for _, line := range utils.Lines(input) {
		numbers := utils.NumbersFromString(line)

		hailstones = append(hailstones, Hailstone{
			x:  float64(numbers[0]),
			y:  float64(numbers[1]),
			z:  float64(numbers[2]),
			px: float64(numbers[3]),
			py: float64(numbers[4]),
			pz: float64(numbers[5]),
		})
	}

	return hailstones
}

func partOne(input string, lowerBound, upperBound float64) int {
	hailstones := parseHailstones(input)

	count := 0

	for i, stoneA := range hailstones {
		for _, stoneB := range hailstones[:i] {

			intersection := stoneA.intersection2d(stoneB)

			if stoneA.isInPast(intersection) || stoneB.isInPast(intersection) {
				continue
			}

			if intersection.x <= upperBound && intersection.x >= lowerBound {
				if intersection.y <= upperBound && intersection.y >= lowerBound {
					count++
				}
			}
		}
	}
	return count
}

func TestPartOne(t *testing.T) {
	got := partOne(TEST_INPUT, 7, 27)
	expected := 2

	if got != expected {
		t.Error("Wrong", got, "Expected", expected)
		return
	}

	fmt.Println(partOne(utils.ReadInput(24), 200000000000000, 400000000000000))
}

func partTwo(input string) int {
	hailstones := parseHailstones(input)
	smtTxt := `
(declare-const x Int)
(declare-const y Int)
(declare-const z Int)
(declare-const dx Int)
(declare-const dy Int)
(declare-const dz Int)
`

	for i, stone := range hailstones[:3] {
		t := i + 1

		smtTxt += fmt.Sprintf("(declare-const t%d Int)\n", t)
		smtTxt += fmt.Sprintf(`
(assert(= (+ (* t%d dx ) x) (+ (* %d t%d) %d)))
		`, t, int(stone.px), t, int(stone.x))
		smtTxt += fmt.Sprintf(`
(assert(= (+ (* t%d dy ) y) (+ (* %d t%d) %d)))
		`, t, int(stone.py), t, int(stone.y))
		smtTxt += fmt.Sprintf(`
(assert(= (+ (* t%d dz ) z) (+ (* %d t%d) %d)))
		`, t, int(stone.pz), t, int(stone.z))
	}

	smtTxt += `
(check-sat)
(eval (+ x y z))
`
	dir := os.TempDir()
	f, err := os.CreateTemp(dir, "z3")

	if err != nil {
		panic(err)
	}

	f.WriteString(smtTxt)

	f.Close()

	fPath := f.Name()
	cmd := exec.Command("z3", "parallel.enable=true", fPath)

	cmd.Wait()

	out, _ := cmd.Output()
	outStr := string(out)
	nums := utils.NumbersFromString(outStr)

	return nums[0]
}

func TestPartTwo(t *testing.T) {
	got := partTwo(TEST_INPUT)
	expected := 47

	if got != expected {
		t.Error("Wrong", got, "Expected", expected)
		return
	}

	fmt.Println(partTwo(utils.ReadInput(24)))
}
