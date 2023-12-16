package day16

import (
	"advent-of-code-2023/utils"
	"fmt"
	"sync"
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
	grid utils.Grid
}

func (m MirrorMaze) FindBeams(startingLoc, startingDir utils.Point) map[utils.Point]int {
	queue := []move{{loc: startingLoc, dir: startingDir}}
	moves := make(map[utils.Point]int)
	cache := make(map[move]int)
	var mv move
	for len(queue) > 0 {
		mv, queue = queue[0], queue[1:]

		if _, ok := cache[mv]; ok || !m.grid.ContainsPoint(mv.loc) {
			continue
		}

		loc := mv.loc
		dir := mv.dir
		cell := m.grid.Data[loc]
		newLoc := loc.Add(dir)
		cache[mv]++
		moves[loc]++

		if cell == '.' {
			queue = append(queue, move{loc: newLoc, dir: dir})
		} else if cell == '|' {
			if dir == RIGHT || dir == LEFT {
				queue = append(queue, move{loc: loc.Up(), dir: UP})
				queue = append(queue, move{loc: loc.Down(), dir: DOWN})
			} else {
				queue = append(queue, move{loc: newLoc, dir: dir})
			}
		} else if cell == '-' {
			if dir == UP || dir == DOWN {
				queue = append(queue, move{loc: loc.Left(), dir: LEFT})
				queue = append(queue, move{loc: loc.Right(), dir: RIGHT})
			} else {
				queue = append(queue, move{loc: newLoc, dir: dir})
			}
		} else if cell == '/' {
			if dir == UP {
				queue = append(queue, move{loc: loc.Right(), dir: RIGHT})
			} else if dir == DOWN {
				queue = append(queue, move{loc: loc.Left(), dir: LEFT})
			} else if dir == LEFT {
				queue = append(queue, move{loc: loc.Down(), dir: DOWN})
			} else if dir == RIGHT {
				queue = append(queue, move{loc: loc.Up(), dir: UP})
			}
		} else if cell == '\\' {
			if dir == DOWN {
				queue = append(queue, move{loc: loc.Right(), dir: RIGHT})
			} else if dir == UP {
				queue = append(queue, move{loc: loc.Left(), dir: LEFT})
			} else if dir == LEFT {
				queue = append(queue, move{loc: loc.Up(), dir: UP})
			} else if dir == RIGHT {
				queue = append(queue, move{loc: loc.Down(), dir: DOWN})
			}
		}
	}

	return moves
}

func TestPartOne(t *testing.T) {
	maze := MirrorMaze{grid: utils.MakeGrid(TEST_CASE)}
	beams := maze.FindBeams(utils.Point{X: 0, Y: 0}, RIGHT)
	got := len(beams)

	if got != 46 {
		t.Error("Wrong answer", got)
	} else {
		maze = MirrorMaze{grid: utils.MakeGrid(input)}
		beams = maze.FindBeams(utils.Point{X: 0, Y: 0}, RIGHT)
		got = len(beams)
		fmt.Println(got)
	}
}

func PartTwo(input string) int {
	grid := utils.MakeGrid(input)
	maze := MirrorMaze{grid: grid}
	max := 0

	answers := make(chan int, (grid.MaxX+grid.MaxY)*2)

	go func() {
		for ans := range answers {
			if ans > max {
				max = ans
			}
		}
	}()

	var wg sync.WaitGroup

	runAsync := func(x, y int, dir utils.Point) {
		defer wg.Done()
		beams := maze.FindBeams(utils.Point{X: x, Y: y}, dir)
		ans := len(beams)
		answers <- ans
	}

	for x := grid.MinX; x <= grid.MaxX; x++ {
		wg.Add(2)
		go runAsync(x, grid.MinY, DOWN)
		go runAsync(x, grid.MaxY, UP)
	}
	for y := grid.MinY; y <= grid.MaxY; y++ {
		wg.Add(2)
		go runAsync(grid.MinX, y, RIGHT)
		go runAsync(grid.MaxX, y, LEFT)
	}

	wg.Wait()

	return max
}

func TestPartTwo(t *testing.T) {
	got := PartTwo(input)

	fmt.Println(got)
}
