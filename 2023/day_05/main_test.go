package day04

import (
	"advent-of-code-2023/utils"
	"fmt"
	"strings"
	"testing"
)

type Almanac struct {
	seeds                 []int
	seedsToSoil           []int
	soilToFertilizer      []int
	fertilizerToWater     []int
	waterToLight          []int
	lightToTemperature    []int
	temperatureToHumidity []int
	humidityToLocation    []int
}

func parseAlmanac(input string) Almanac {
	almanac := Almanac{}

	sections := strings.Split(input, "\n\n")
	almanac.seeds = utils.NumbersFromString(sections[0])
	almanac.seedsToSoil = utils.NumbersFromString(sections[1])
	almanac.soilToFertilizer = utils.NumbersFromString(sections[2])
	almanac.fertilizerToWater = utils.NumbersFromString(sections[3])
	almanac.waterToLight = utils.NumbersFromString(sections[4])
	almanac.lightToTemperature = utils.NumbersFromString(sections[5])
	almanac.temperatureToHumidity = utils.NumbersFromString(sections[6])
	almanac.humidityToLocation = utils.NumbersFromString(sections[7])

	return almanac
}

func getDestination(mappings []int, val int) int {
	for i := 0; i < len(mappings); i = i + 3 {
		dest, source, len := mappings[i], mappings[i+1], mappings[i+2]

		if val >= source && val <= source+len {
			diff := val - source
			return dest + diff
		}
	}

	return val
}

func (a Almanac) SeedToLocation(seed int) int {
	soil := getDestination(a.seedsToSoil, seed)
	fertilizer := getDestination(a.soilToFertilizer, soil)
	water := getDestination(a.fertilizerToWater, fertilizer)
	light := getDestination(a.waterToLight, water)
	temperature := getDestination(a.lightToTemperature, light)
	humidity := getDestination(a.temperatureToHumidity, temperature)
	location := getDestination(a.humidityToLocation, humidity)

	return location
}

func TestPartOne(t *testing.T) {

	input := utils.ReadInput(5)
	almanac := parseAlmanac(input)

	least := 999999999

	for _, seed := range almanac.seeds {
		loc := almanac.SeedToLocation(seed)

		if loc < least {
			least = loc
		}
	}

	fmt.Println(least)
}
