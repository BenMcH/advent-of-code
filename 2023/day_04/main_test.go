package day04

import (
	"advent-of-code-2023/utils"
	"fmt"
	"regexp"
	"strings"
	"testing"
)

func parseCard(input string) int {
	input = strings.Trim(input, "\n")
	regex := regexp.MustCompile(`\d+`)
	cards := strings.Split(input, "\n")
	sum := 0

	for _, card := range cards {
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

		sum = sum + score

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
	if parseCard(testInput) != 13 {
		t.Errorf("Expected 13, got: %d", parseCard(testInput))
	}

	input := utils.ReadInput(4)

	fmt.Println(parseCard(input))
}
