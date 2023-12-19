package day18

import (
	"advent-of-code-2023/utils"
	"fmt"
	"strconv"
	"strings"
	"testing"
)

const TEST_INPUT = `R 6 (#70c710)
D 5 (#0dc571)
L 2 (#5713f0)
D 2 (#d2c081)
R 2 (#59c680)
D 2 (#411b91)
L 5 (#8ceee2)
U 2 (#caa173)
L 1 (#1b58a2)
U 2 (#caa171)
R 2 (#7807d2)
U 3 (#a77fa3)
L 2 (#015232)
U 2 (#7a21e3)
`

var REAL_INPUT = utils.ReadInput(18)

type LineSegment struct {
	start, end utils.Point
}

type DigMovement struct {
	direction string
	distance  int
}

func parsePartOneInput(input string) []DigMovement {
	lines := utils.Lines(input)
	arr := make([]DigMovement, len(lines))
	for i, line := range lines {
		parts := strings.Split(line, " ")
		dist, _ := strconv.Atoi(parts[1])

		arr[i] = DigMovement{
			direction: parts[0],
			distance:  dist,
		}
	}

	return arr
}

func parsePartTwoInput(input string) []DigMovement {
	dirMap := map[byte]string{
		'2': "L",
		'0': "R",
		'3': "U",
		'1': "D",
	}
	lines := utils.Lines(input)
	arr := make([]DigMovement, len(lines))
	for i, line := range lines {
		parts := strings.Split(line, " ")
		str := parts[2]
		str = "" + str[2:8]
		directionNum := str[len(str)-1]
		str = str[0 : len(str)-1]
		dist, _ := strconv.ParseInt(str, 16, 64)

		arr[i] = DigMovement{
			direction: dirMap[directionNum],
			distance:  int(dist),
		}
	}

	return arr
}

func PartOne(input string) int {
	movements := parsePartOneInput(input)

	return findArea(movements)
}

func shoelace(segments []LineSegment) int {
	a := 0
	b := 0

	segmentCopy := make([]LineSegment, len(segments))
	copy(segmentCopy, segments)

	for _, segment := range segmentCopy {
		b = b + (segment.start.Y * segment.end.X)
		a = a + segment.start.X*segment.end.Y
	}

	total := a - b

	if total < 0 {
		total = -total
	}

	return total / 2
}

func findArea(movement []DigMovement) int {
	point := utils.Point{X: 0, Y: 0}
	total := 0

	dirMap := map[string]utils.Point{
		"L": point.Left(),
		"R": point.Right(),
		"U": point.Up(),
		"D": point.Down(),
	}

	borders := make([]LineSegment, 0)

	for _, mv := range movement {
		dir := dirMap[mv.direction]
		total += mv.distance

		amplitude := dir.Multiply(mv.distance)
		end := point.Add(amplitude)

		segment := LineSegment{
			start: point,
			end:   end,
		}

		borders = append(borders, segment)
		point = end
	}

	return shoelace(borders) + total/2 + 1
}

func TestPartOne(t *testing.T) {
	got := PartOne(TEST_INPUT)

	if got != 62 {
		t.Error("Wrong", got, "Expected", 62)
		return
	}

	fmt.Println(PartOne(REAL_INPUT))
}

func PartTwo(input string) int {
	movements := parsePartTwoInput(input)

	return findArea(movements)
}

func TestPartTwo(t *testing.T) {
	got := PartTwo(TEST_INPUT)

	if got != 952408144115 {
		t.Error("Wrong", got, "Expected", 952408144115)
		return
	}

	fmt.Println(PartTwo(REAL_INPUT))
}
