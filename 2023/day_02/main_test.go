package day02

import (
	"advent-of-code-2023/utils"
	"fmt"
	"strconv"
	"strings"
	"testing"
)

type Game struct {
	id, blue, red, green int
}

func ParseGame(game string) Game {
	sections := strings.Split(game, ":")
	id, _ := strconv.Atoi(strings.Split(sections[0], " ")[1])
	rounds := strings.Split(sections[1], "; ")
	g := Game{id: id}
	for _, round := range rounds {
		moves := strings.Split(strings.TrimLeft(round, " "), ", ")
		for _, move := range moves {
			vals := strings.Split(move, " ")
			num, _ := strconv.Atoi(vals[0])

			if strings.Contains(vals[1], "blue") && num > g.blue {
				g.blue = num
			} else if strings.Contains(vals[1], "red") && num > g.red {
				g.red = num
			} else if strings.Contains(vals[1], "green") && num > g.green {
				g.green = num
			}

		}
	}
	return g
}

func (g Game) PartOnePossible() bool {
	return g.red <= 12 && g.green <= 13 && g.blue <= 14
}
func (g Game) Power() int {
	return g.red * g.blue * g.green
}

func TestPartOne(t *testing.T) {
	games := utils.Lines(utils.ReadInput(2))

	sum := 0
	for _, game := range games {
		game := ParseGame(game)

		if game.PartOnePossible() {
			sum += game.id
		}
	}

	fmt.Println(sum)
}

func TestPartTwo(t *testing.T) {
	games := utils.Lines(utils.ReadInput(2))

	sum := 0
	for _, game := range games {
		sum += ParseGame(game).Power()
	}

	fmt.Println(sum)
}
