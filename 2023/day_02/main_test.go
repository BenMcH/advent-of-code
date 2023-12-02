package day02

import (
	"advent-of-code-2023/utils"
	"fmt"
	"strconv"
	"strings"
	"testing"
)

type Game struct {
	blue, red, green int
}

func ParseGame(rounds []string) Game {
	g := Game{}
	for _, round := range rounds {
		moves := strings.Split(strings.TrimLeft(round, " "), ", ")
		for _, move := range moves {
			vals := strings.Split(move, " ")
			num, _ := strconv.Atoi(vals[0])

			if strings.HasPrefix(vals[1], "blue") {
				g.blue = num
			} else if strings.HasPrefix(vals[1], "red") {
				g.red = num
			} else if strings.HasPrefix(vals[1], "green") {
				g.green = num
			} else {
				fmt.Println("No idea", vals)
			}

			if !g.PartOnePossible() {
				return g
			}
		}
	}
	return g
}
func ParseGame2(rounds []string) Game {
	g := Game{}
	for _, round := range rounds {
		moves := strings.Split(strings.TrimLeft(round, " "), ", ")
		for _, move := range moves {
			vals := strings.Split(move, " ")
			num, _ := strconv.Atoi(vals[0])

			if strings.HasPrefix(vals[1], "blue") && num > g.blue {
				g.blue = num
			} else if strings.HasPrefix(vals[1], "red") && num > g.red {
				g.red = num
			} else if strings.HasPrefix(vals[1], "green") && num > g.green {
				g.green = num
			} else {
				fmt.Println("No idea", vals)
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
	input := utils.ReadInput(2)
	games := strings.Split(input, "\n")

	sum := 0
	for _, game := range games {
		sections := strings.Split(game, ":")
		id, _ := strconv.Atoi(strings.Split(sections[0], " ")[1])
		rounds := strings.Split(sections[1], "; ")
		game := ParseGame(rounds)
		fmt.Println(game)

		if game.PartOnePossible() {
			sum += id
		}
	}

	fmt.Println(sum)
}

func TestPartTwo(t *testing.T) {
	input := utils.ReadInput(2)
	games := strings.Split(input, "\n")

	sum := 0
	for _, game := range games {
		sections := strings.Split(game, ":")
		rounds := strings.Split(sections[1], "; ")
		game := ParseGame2(rounds)
		sum += game.Power()
	}

	fmt.Println(sum)
}
