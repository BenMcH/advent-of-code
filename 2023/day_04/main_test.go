package day04

import (
	"advent-of-code-2023/utils"
	"fmt"
	"slices"
	"strings"
	"testing"
)

type Card struct {
	winning []int
	myCard  []int
}

func NewCard(input string) Card {
	sections := strings.Split(input, ":")
	numberSections := strings.Split(sections[1], "|")

	firstNumbers := utils.NumbersFromString(numberSections[0])
	secondNumbers := utils.NumbersFromString(numberSections[1])
	return Card{firstNumbers, secondNumbers}
}

func (card Card) Score() int {
	cards := utils.Filter(card.myCard, func(val, _ int) bool { return slices.Contains(card.winning, val) })
	score := utils.IntPow(2, len(cards)-1)

	return score
}

func scoreCards(input string) int {
	cards := utils.Lines(input)
	sum := utils.SumIntArr(utils.Map(cards, func(c string, _ int) int {
		return NewCard(c).Score()
	}))

	return sum
}

func scoreRecursively(cards []string, workingSet []int, cache map[int]int) int {
	if len(workingSet) == 0 {
		return 0
	}
	currentCard := workingSet[0]
	workingSet = workingSet[1:]
	card := NewCard(cards[currentCard])

	if val, ok := cache[currentCard]; ok {
		return val + scoreRecursively(cards, workingSet, cache)
	}
	target := currentCard

	newCards := make([]int, 0)
	for _, val := range card.winning {
		if slices.Contains(card.myCard, val) {
			target = target + 1
			newCards = append(newCards, target)
		}
	}

	cache[currentCard] = 1 + scoreRecursively(cards, newCards, cache)

	return cache[currentCard] + scoreRecursively(cards, workingSet, cache)
}

func PartTwo(input string) int {
	cardStrings := utils.Lines(input)
	scores := make([]int, len(cardStrings))
	indicies := make([]int, len(cardStrings))

	for i, card := range cardStrings {
		scores[i] = NewCard(card).Score()
		indicies[i] = i
	}

	return scoreRecursively(cardStrings, indicies, make(map[int]int))
}

func TestPartOne(t *testing.T) {
	testInput := `
Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
`
	if scoreCards(testInput) != 13 {
		t.Errorf("Expected 13, got: %d", scoreCards(testInput))
	}

	input := utils.ReadInput(4)
	fmt.Println(scoreCards(input))
}

func TestPartTwo(t *testing.T) {
	testInput := `
Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
`
	testInput = strings.Trim(testInput, "\n")

	if PartTwo(testInput) != 30 {
		t.Errorf("Expected 30, got: %d", PartTwo(testInput))
	}

	input := utils.ReadInput(4)
	fmt.Println(PartTwo(input))
}
