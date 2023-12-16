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

type MirrorMaze struct {
	grid  utils.Grid
	cache map[move]map[utils.Point]int
}

func (m MirrorMaze) FindBeams(loc, dir utils.Point, beams map[utils.Point]int) map[utils.Point]int {
	mv := move{loc, dir}
	if loc.X < m.grid.MinX || loc.X > m.grid.MaxX || loc.Y < m.grid.MinY || loc.Y > m.grid.MaxY {

		return map[utils.Point]int{}
	}

	moves := beams
	moves[loc]++
	if _, ok := m.cache[mv]; ok {
		return map[utils.Point]int{}
	} else {
		m.cache[mv] = moves

		cell := m.grid.Data[loc]
		newLoc := loc.Add(dir)

		if cell == '.' {
			m.FindBeams(newLoc, dir, moves)
		} else if cell == '|' {

			if dir == RIGHT || dir == LEFT {
				m.FindBeams(loc.Up(), UP, moves)
				m.FindBeams(loc.Down(), DOWN, moves)
			} else {
				m.FindBeams(newLoc, dir, moves)
			}
		} else if cell == '-' {
			if dir == UP || dir == DOWN {
				m.FindBeams(loc.Left(), LEFT, moves)
				m.FindBeams(loc.Right(), RIGHT, moves)
			} else {
				m.FindBeams(newLoc, dir, moves)
			}
		} else if cell == '/' {
			if dir == UP {
				m.FindBeams(loc.Right(), RIGHT, moves)
			}
			if dir == DOWN {
				m.FindBeams(loc.Left(), LEFT, moves)
			}
			if dir == LEFT {
				m.FindBeams(loc.Down(), DOWN, moves)
			}
			if dir == RIGHT {
				m.FindBeams(loc.Up(), UP, moves)
			}
		} else if cell == '\\' {
			if dir == DOWN {
				m.FindBeams(loc.Right(), RIGHT, moves)
			}
			if dir == UP {
				m.FindBeams(loc.Left(), LEFT, moves)
			}
			if dir == LEFT {
				m.FindBeams(loc.Up(), UP, moves)
			}
			if dir == RIGHT {
				m.FindBeams(loc.Down(), DOWN, moves)
			}
		}
	}

	// for k, v := range moves {
	// 	beams[k] = v
	// }

	return beams
	// return len(beams)
}


func TestPartOne(t *testing.T) {
	maze := MirrorMaze{grid: utils.MakeGrid(TEST_CASE), cache: make(map[move]map[utils.Point]int)}
	beams := maze.FindBeams(utils.Point{X: 0, Y: 0}, RIGHT, make(map[utils.Point]int))
	got := len(beams)

	if got != 46 {
		t.Error("Wrong answer", got)
	} else {
		maze = MirrorMaze{grid: utils.MakeGrid(input), cache: make(map[move]map[utils.Point]int)}
		beams = maze.FindBeams(utils.Point{X: 0, Y: 0}, RIGHT, make(map[utils.Point]int))
		got = len(beams)
		fmt.Println(got)
	}
}

func PartTwo(input string) int {
	grid := utils.MakeGrid(input)
	maze := MirrorMaze{
		grid:  grid,
		cache: make(map[move]map[utils.Point]int),
	}
	max := 0

	for x := grid.MinX; x <= grid.MaxX; x++ {
		beams := maze.FindBeams(utils.Point{X: x, Y: grid.MinY}, DOWN, make(map[utils.Point]int))
		ans := len(beams)
		maze.cache = map[move]map[utils.Point]int{}
		if ans > max {
			max = ans
		}
		beams = maze.FindBeams(utils.Point{X: x, Y: grid.MaxY}, UP, make(map[utils.Point]int))
		maze.cache = map[move]map[utils.Point]int{}
		ans = len(beams)
		if ans > max {
			max = ans
		}
	}
	for y := grid.MinY; y <= grid.MaxY; y++ {
		beams := maze.FindBeams(utils.Point{X: grid.MinX, Y: y}, RIGHT, make(map[utils.Point]int))
		ans := len(beams)
		maze.cache = map[move]map[utils.Point]int{}
		if ans > max {
			max = ans
		}
		beams = maze.FindBeams(utils.Point{X: grid.MaxX, Y: y}, LEFT, make(map[utils.Point]int))
		ans = len(beams)
		maze.cache = map[move]map[utils.Point]int{}
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
