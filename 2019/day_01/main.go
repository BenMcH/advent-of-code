package day_01

import (
	"advent-of-code-2019/utils"
	"strings"
)

func PartOne(str string) int {
	sum := 0
	nums, err := utils.StringsToInts(strings.Split(str, "\n"))

	if err != nil {
		panic(err)
	}

	for _, number := range nums {
		sum += int(calculateFuel(number))
	}
	return sum
}

func PartTwo(arr string) int {
	sum := 0
	nums, err := utils.StringsToInts(strings.Split(arr, "\n"))

	if err != nil {
		panic(err)
	}

	for _, number := range nums {
		sum += calculateFuelRecursive(number)
	}
	return sum
}

func calculateFuel(mass int) int {
	return mass/3 - 2
}

func calculateFuelRecursive(mass int) int {
	sum := 0
	for mass > 0 {
		mass = calculateFuel(mass)
		if mass > 0 {
			sum += mass
		}
	}

	return sum
}
