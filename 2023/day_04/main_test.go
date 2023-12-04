package day04

import (
	"advent-of-code-2023/utils"
	"fmt"
	"regexp"
	"strings"
	"testing"
)

func parseCard(card string) int {
	regex := regexp.MustCompile(`\d+`)
	sections := strings.Split(card, ":")
	numberSections := strings.Split(sections[1], "|")

	firstNumbers := regex.FindAllString(numberSections[0], -1)
	secondNumbers := regex.FindAllString(numberSections[1], -1)

	myCard := make(map[string]bool)
	// secondMap := make(map[string]bool)

	for _, val := range secondNumbers {
		myCard[val] = true
	}

	score := 0

	for _, val := range firstNumbers {
		if _, ok := myCard[val]; ok {
			if score == 0 {
				score = 1
			} else {
				score = score * 2
			}
		}
	}

	return score
}

func parseCards(input string) int {
	input = strings.Trim(input, "\n")
	cards := strings.Split(input, "\n")
	sum := 0

	for _, card := range cards {
		sum = sum + parseCard(card)
	}
	return sum
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
	if parseCards(testInput) != 13 {
		t.Errorf("Expected 13, got: %d", parseCards(testInput))
	}

	input := utils.ReadInput(4)

	fmt.Println(parseCards(input))
}

func scoreRecursively(cards []string, workingSet []int, cache map[int]int) int {
	if len(workingSet) == 0 {
		return 0
	}
	currentCard := workingSet[0]
	workingSet = workingSet[1:]
	card := cards[currentCard]

	if val, ok := cache[currentCard]; ok {
		return val + scoreRecursively(cards, workingSet, cache)
	}

	regex := regexp.MustCompile(`\d+`)
	sections := strings.Split(card, ":")
	numberSections := strings.Split(sections[1], "|")

	firstNumbers := regex.FindAllString(numberSections[0], -1)
	secondNumbers := regex.FindAllString(numberSections[1], -1)

	myCard := make(map[string]bool, 0)
	// secondMap := make(map[string]bool)

	for _, val := range secondNumbers {
		myCard[val] = true
	}

	matches := 0

	for _, val := range firstNumbers {
		if _, ok := myCard[val]; ok {
			matches = matches + 1
		}
	}

	target := currentCard + 0 + matches

	newCards := make([]int, 0)

	for i := currentCard + 1; i <= target; i++ {
		newCards = append(newCards, i)
	}

	cache[currentCard] = 1 + scoreRecursively(cards, newCards, cache)

	return cache[currentCard] + scoreRecursively(cards, workingSet, cache)
}

func PartTwo(input string) int {
	input = strings.Trim(input, "\n")

	cardStrings := strings.Split(input, "\n")

	scores := make([]int, len(cardStrings))

	for i, card := range cardStrings {
		scores[i] = parseCard(card)
	}

	// recursiveScores := make(map[int]int)
	indicies := make([]int, 0)
	for i := range cardStrings {
		indicies = append(indicies, i)
	}

	return scoreRecursively(cardStrings, indicies, make(map[int]int))
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
