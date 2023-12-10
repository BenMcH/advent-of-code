package day09

import (
	"advent-of-code-2023/utils"
	"fmt"
	"testing"
)

type weather struct {
	history     []int
	predictions *weather
}

func (w *weather) generatePredictionModel() {
	if utils.Any(w.history, func(i int) bool { return i != 0 }) {
		newHistory := make([]int, len(w.history)-1)
		for i := range newHistory {
			newHistory[i] = w.history[i+1] - w.history[i]
		}
		w.predictions = &weather{newHistory, nil}

		w.predictions.generatePredictionModel()
	}
}

func (w weather) predict() int {
	prediction := w.history[len(w.history)-1]
	if w.predictions != nil {
		prediction = prediction + w.predictions.predict()
	}

	return prediction
}

func (w weather) predictHistorical() int {
	prediction := w.history[0]
	if w.predictions != nil {
		prediction = prediction - w.predictions.predictHistorical()
	}

	return prediction
}

func parseWeather(input string) weather {
	nums := utils.NumbersFromString(input)
	w := weather{nums, nil}

	w.generatePredictionModel()

	return w
}

func TestWeather(t *testing.T) {
	w := parseWeather("0 3 6 9 12 15")

	if w.predict() != 18 {
		t.Error("Wrong prediction. Expected 18. Got: ", w.predict())
	}
}

func partOne(input string) int {
	lines := utils.Lines(input)

	predictions := utils.Map(lines, func(input string, _ int) int { return parseWeather(input).predict() })

	return utils.SumIntArr(predictions)
}

func TestPartOne(t *testing.T) {
	testinput := `0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45
`
	if partOne(testinput) != 114 {
		t.Error("Wrong", partOne(testinput))
	} else {
		fmt.Println(partOne(utils.ReadInput(9)))
	}
}

func partTwo(input string) int {
	lines := utils.Lines(input)

	predictions := utils.Map(lines, func(input string, _ int) int { return parseWeather(input).predictHistorical() })

	return utils.SumIntArr(predictions)
}

func TestPartTwo(t *testing.T) {
	testinput := `10 13 16 21 30 45`
	if partTwo(testinput) != 5 {
		t.Error("Wrong", partTwo(testinput))
	} else {
		fmt.Println(partTwo(utils.ReadInput(9)))
	}
}
