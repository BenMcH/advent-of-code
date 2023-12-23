package utils

import (
	"fmt"
	"strings"
)

type Point struct {
	X, Y int
}

func (p Point) Copy() Point {
	return Point{
		X: p.X,
		Y: p.Y,
	}
}

func (p Point) Add(p1 Point) Point {
	return Point{
		X: p.X + p1.X,
		Y: p.Y + p1.Y,
	}
}

func (p Point) Diff(p1 Point) Point {
	return Point{
		X: p1.X - p.X,
		Y: p1.Y - p.Y,
	}
}

func (p Point) Multiply(i int) Point {
	return Point{
		X: p.X * i,
		Y: p.Y * i,
	}
}

func (p Point) Left() Point {
	return Point{X: p.X - 1, Y: p.Y}
}

func (p Point) Right() Point {
	return Point{X: p.X + 1, Y: p.Y}
}

func (p Point) Up() Point {
	return Point{X: p.X, Y: p.Y - 1}
}

func (p Point) Down() Point {
	return Point{X: p.X, Y: p.Y + 1}
}

func (p Point) ManhattenDistance(p2 Point) int {
	return intAbs(p.X-p2.X) + intAbs(p.Y-p2.Y)
}

func intAbs(input int) int {
	if input < 0 {
		return -1 * input
	}
	return input
}

type Grid struct {
	Data                   map[Point]rune
	MinX, MaxX, MinY, MaxY int
}

func MakeGrid(input string) (grid Grid) {
	input = strings.Trim(input, "\n")
	grid = Grid{Data: make(map[Point]rune)}

	lines := strings.Split(input, "\n")

	grid.MinX = 0
	grid.MaxX = len(lines[0]) - 1

	grid.MinY = 0
	grid.MaxY = len(lines) - 1

	for y, line := range lines {
		for x, rn := range line {
			grid.Data[Point{X: x, Y: y}] = rn
		}
	}

	return
}

func (grid Grid) ContainsPoint(p Point) bool {
	return p.X >= grid.MinX && p.X <= grid.MaxX && p.Y >= grid.MinY && p.Y <= grid.MaxY
}

func (grid Grid) Print() {
	for y := grid.MinY; y <= grid.MaxY; y++ {
		for x := grid.MinX; x <= grid.MaxX; x++ {
			loc := Point{X: x, Y: y}
			fmt.Print(string(grid.Data[loc]))
		}
		fmt.Println()
	}
}

func (p Point) Neighbors4() []Point {
	arr := make([]Point, 4)

	arr[0] = p.Up()
	arr[1] = p.Down()
	arr[2] = p.Left()
	arr[3] = p.Right()

	return arr
}

func (p Point) IsAdjacent(p2 Point) bool {
	pNeighbors := p.Neighbors4()

	for _, neighbor := range pNeighbors {
		if neighbor == p2 {
			return true
		}
	}

	return false
}

func (p Point) Neighbors8() []Point {
	arr := make([]Point, 8)

	arr[0] = p.Left()
	arr[1] = p.Left().Up()
	arr[2] = p.Left().Down()
	arr[3] = p.Up()
	arr[4] = p.Down()
	arr[5] = p.Right()
	arr[6] = p.Right().Up()
	arr[7] = p.Right().Down()

	return arr
}
