package day16

import (
	"advent-of-code-2023/utils"
	"fmt"
	"testing"
)

const TEST_CASE = `.|...\....
|.-.\.....
.....|-...
........|.
..........
.........\
..../.\\..
.-.-/..|..
.|....-|.\
..//.|....`

var input = utils.ReadInput(16)

var LEFT = utils.Point{X: -1, Y: 0}
var RIGHT = utils.Point{X: 1, Y: 0}
var UP = utils.Point{X: 0, Y: -1}
var DOWN = utils.Point{X: 0, Y: 1}

type move struct {
	loc, dir utils.Point
}

func FindEnergyLevel(grid utils.Grid, loc, dir utils.Point, beams map[utils.Point]int, moves map[move]int) int {
	mv := move{loc, dir}
	if _, ok := moves[mv]; ok {
		return 0
	}
	moves[mv]++
	if loc.X < grid.MinX || loc.X > grid.MaxX || loc.Y < grid.MinY || loc.Y > grid.MaxY {
		return 0
	}

	beams[loc]++
	cell := grid.Data[loc]
	newLoc := loc.Add(dir)

	if cell == '.' {
		FindEnergyLevel(grid, newLoc, dir, beams, moves)
	} else if cell == '|' {
		if dir == RIGHT || dir == LEFT {
			FindEnergyLevel(grid, loc.Up(), UP, beams, moves)
			FindEnergyLevel(grid, loc.Down(), DOWN, beams, moves)
		} else {
			FindEnergyLevel(grid, newLoc, dir, beams, moves)
		}
	} else if cell == '-' {
		if dir == UP || dir == DOWN {
			FindEnergyLevel(grid, loc.Left(), LEFT, beams, moves)
			FindEnergyLevel(grid, loc.Right(), RIGHT, beams, moves)
		} else {
			FindEnergyLevel(grid, newLoc, dir, beams, moves)
		}
	} else if cell == '/' {
		if dir == UP {
			FindEnergyLevel(grid, loc.Right(), RIGHT, beams, moves)
		}
		if dir == DOWN {
			FindEnergyLevel(grid, loc.Left(), LEFT, beams, moves)
		}
		if dir == LEFT {
			FindEnergyLevel(grid, loc.Down(), DOWN, beams, moves)
		}
		if dir == RIGHT {
			FindEnergyLevel(grid, loc.Up(), UP, beams, moves)
		}
	} else if cell == '\\' {
		if dir == DOWN {
			FindEnergyLevel(grid, loc.Right(), RIGHT, beams, moves)
		}
		if dir == UP {
			FindEnergyLevel(grid, loc.Left(), LEFT, beams, moves)
		}
		if dir == LEFT {
			FindEnergyLevel(grid, loc.Up(), UP, beams, moves)
		}
		if dir == RIGHT {
			FindEnergyLevel(grid, loc.Down(), DOWN, beams, moves)
		}
	}

	return len(beams)
}

func TestPartOne(t *testing.T) {
	got := FindEnergyLevel(utils.MakeGrid(TEST_CASE), utils.Point{X: 0, Y: 0}, RIGHT, make(map[utils.Point]int), map[move]int{})

	if got != 46 {
		t.Error("Wrong answer", got)
	} else {
		got = FindEnergyLevel(utils.MakeGrid(input), utils.Point{X: 0, Y: 0}, RIGHT, make(map[utils.Point]int), map[move]int{})
		fmt.Println(got)
	}
}

func PartTwo(input string) int {
	grid := utils.MakeGrid(input)
	max := 0

	for x := grid.MinX; x <= grid.MaxX; x++ {
		ans := FindEnergyLevel(grid, utils.Point{X: x, Y: grid.MinY}, DOWN, make(map[utils.Point]int), make(map[move]int))
		if ans > max {
			max = ans
		}
		ans = FindEnergyLevel(grid, utils.Point{X: x, Y: grid.MaxY}, UP, make(map[utils.Point]int), make(map[move]int))
		if ans > max {
			max = ans
		}
	}
	for y := grid.MinY; y <= grid.MaxY; y++ {
		ans := FindEnergyLevel(grid, utils.Point{X: grid.MinX, Y: y}, RIGHT, make(map[utils.Point]int), make(map[move]int))
		if ans > max {
			max = ans
		}
		ans = FindEnergyLevel(grid, utils.Point{X: grid.MaxX, Y: y}, LEFT, make(map[utils.Point]int), make(map[move]int))
		if ans > max {
			max = ans
		}
	}
	return max
}

func TestPartTwo(t *testing.T) {
	got := PartTwo(input)

	fmt.Println(got)
}
