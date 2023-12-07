package day07

import (
	"advent-of-code-2023/utils"
	"fmt"
	"slices"
	"strconv"
	"strings"
	"testing"
)

type player struct {
	hand          []rune
	bid           int
	handTypeScore int
}

func (p player) equals(p2 player) bool {
	return p.handTypeScore == p2.handTypeScore && p.bid == p2.bid
}

func NewPlayer(input string, partTwo bool) player {
	sections := strings.Split(input, " ")
	bid, _ := strconv.Atoi(sections[1])
	hand := []rune(sections[0])

	return player{
		hand,
		bid,
		scoreHandType(hand, partTwo),
	}
}

func (p player) determineWinner(opponent player, partTwo bool) player {
	if p.handTypeScore > opponent.handTypeScore {
		return p
	} else if opponent.handTypeScore > p.handTypeScore {
		return opponent
	}

	return determineWinnerHighCard(p, opponent, partTwo)
}

func determineWinnerHighCard(p1, p2 player, partTwo bool) player {
	for i, card := range p1.hand {
		p2Card := p2.hand[i]

		p1Score := scoreCardType(card, partTwo)
		p2Score := scoreCardType(p2Card, partTwo)

		if p1Score > p2Score {
			return p1
		}
		if p2Score > p1Score {
			return p2
		}
	}

	panic("No obvious winner")
}

const (
	highCard     = iota
	onePair      = iota
	twoPair      = iota
	threeOfAKind = iota
	fullHouse    = iota
	fourOfAKind  = iota
	fiveOfAKind  = iota
)

func scoreHandType(input []rune, partTwo bool) int {
	cards := make(map[rune]int)
	for _, r := range input {
		cards[r]++
	}

	_, hasJoker := cards['J']

	if hasJoker && partTwo {
		candidates := make([]rune, 0)
		for key := range cards {
			if key != 'J' {
				candidates = append(candidates, key)
			}
		}

		if len(candidates) == 0 { // JJJJJ
			return scoreHandType(input, false)
		}

		max := 0
		for _, c := range candidates {
			nCards := make([]rune, len(input))
			copy(nCards, input)

			i := slices.Index(nCards, 'J')
			nCards[i] = c
			num := scoreHandType(nCards, partTwo)
			if num > max {
				max = num
			}
		}
		return max
	}

	return scoreHandMap(cards)
}

func scoreHandMap(cards map[rune]int) int {
	vals := make([]int, 0)
	for _, val := range cards {
		vals = append(vals, val)
	}

	if slices.Contains(vals, 5) {
		return fiveOfAKind
	}

	if slices.Contains(vals, 4) {
		return fourOfAKind
	}
	if slices.Contains(vals, 3) {
		if slices.Contains(vals, 2) {
			return fullHouse
		}
		return threeOfAKind
	}

	if slices.Contains(vals, 2) {
		count := 0
		for _, val := range vals {
			if val == 2 {
				count++
			}
		}
		if count == 2 {
			return twoPair
		}

		return onePair
	}

	return highCard
}

func scoreCardType(card rune, partTwo bool) int {
	cardPoints := make(map[rune]int)
	cards := []rune{'2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A'}
	for i, card := range cards {
		cardPoints[card] = i
	}

	if partTwo {
		cardPoints['J'] = -1
	}

	return cardPoints[card]
}

const TEST_INPUT = `2345A 1
Q2KJJ 13
Q2Q2Q 19
T3T3J 17
T3Q33 11
2345J 3
J345A 2
32T3K 5
T55J5 29
KK677 7
KTJJT 34
QQQJA 31
JJJJJ 37
JAAAA 43
AAAAJ 59
AAAAA 61
2AAAA 23
2JJJJ 53
JJJJ2 41`

func ProcessHands(input string, partTwo bool) int {
	handStrs := utils.Lines(input)

	hands := make([]player, len(handStrs))
	for i, str := range handStrs {
		hands[i] = NewPlayer(str, partTwo)
	}

	slices.SortFunc(hands, func(a, b player) int {
		winner := a.determineWinner(b, partTwo)

		if b.equals(winner) {
			return -1
		} else {
			return 1
		}
	})

	totalWinnings := 0

	for i, player := range hands {
		totalWinnings = totalWinnings + (1+i)*player.bid
	}

	return totalWinnings
}

func TestPartOne(t *testing.T) {
	if ProcessHands(TEST_INPUT, false) != 6592 {
		t.Error("Wrong", ProcessHands(TEST_INPUT, false))
	} else {
		fmt.Println(ProcessHands(utils.ReadInput(7), false))
	}
}

func TestPartTwo(t *testing.T) {
	if ProcessHands(TEST_INPUT, true) != 6839 {
		t.Error("Wrong", ProcessHands(TEST_INPUT, true))
	} else {
		fmt.Println(ProcessHands(utils.ReadInput(7), true))
	}
}
