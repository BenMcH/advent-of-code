package day_03

import (
	"strconv"
	"strings"
)

type Point struct {
	X, Y int
}

func (p Point) ManhattenDistance() int {
	x := p.X
	y := p.Y

	if x < 0 {
		x = -x
	}
	if y < 0 {
		y = -y
	}

	return x + y
}

type LineSegment struct {
	Start, End Point
}

type Wire struct {
	Segments []LineSegment
}

func (w Wire) Points() (points map[Point]int) {
	points = make(map[Point]int)
	step := 0
	for lineIndex, lineSegment := range w.Segments {
		pointIndex := 0
		for _, point := range lineSegment.Points() {
			if _, ok := points[point]; !ok {
				points[point] = step
			}

			if lineIndex == 0 || pointIndex != 0 { // count the first element on line 1 else skip it. This is due to the fact that one line segments ending is the next's starting point
				step += 1
			}
			pointIndex += 1
		}
	}

	return
}

func (l LineSegment) Points() (points []Point) {
	dir := 1

	if l.Start.X == l.End.X { // Line is Vertical
		if l.End.Y < l.Start.Y {
			dir *= -1
		}

		for y := l.Start.Y; y != l.End.Y+dir; y += dir {
			point := Point{l.Start.X, y}

			points = append(points, point)
		}
	} else {
		if l.End.X < l.Start.X {
			dir *= -1
		}

		for x := l.Start.X; x != l.End.X+dir; x += dir {
			point := Point{x, l.Start.Y}

			points = append(points, point)
		}
	}

	return
}

func ParseWire(instructions string) (wire Wire) {
	inst := strings.Split(instructions, ",")
	x, y := 0, 0

	for _, instruction := range inst {
		op, numStr := instruction[0], instruction[1:]
		num, _ := strconv.Atoi(numStr)

		point := Point{x, y}

		switch op {
		case 'D':
			y -= num
		case 'U':
			y += num
		case 'L':
			x -= num
		case 'R':
			x += num
		}

		wire.Segments = append(wire.Segments, LineSegment{Start: point, End: Point{x, y}})
	}
	return
}

func PartOne(input string) int {
	lines := strings.Split(input, "\n")
	wireOne := ParseWire(lines[0])
	wireTwo := ParseWire(lines[1])

	wOnePoints := wireOne.Points()
	wTwoPoints := wireTwo.Points()

	var intersectionPoint, origin Point

	for currentPoint := range wOnePoints {
		if _, ok := wTwoPoints[currentPoint]; ok {
			if intersectionPoint == origin || (currentPoint != origin && currentPoint.ManhattenDistance() < intersectionPoint.ManhattenDistance()) {
				intersectionPoint = currentPoint
			}
		}
	}

	return intersectionPoint.ManhattenDistance()
}

func PartTwo(input string) int {
	lines := strings.Split(input, "\n")
	wireOne := ParseWire(lines[0])
	wireTwo := ParseWire(lines[1])

	combinedSteps := -1

	wOnePoints := wireOne.Points()
	wTwoPoints := wireTwo.Points()

	origin := Point{}
	for point, firstSteps := range wOnePoints {
		if point == origin {
			continue
		}
		if _, ok := wTwoPoints[point]; ok {
			secondSteps := wTwoPoints[point]

			currentSteps := firstSteps + secondSteps

			if currentSteps < combinedSteps || combinedSteps < 0 {
				combinedSteps = currentSteps
			}
		}
	}

	return combinedSteps
}
