package day05

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

func getSource(mappings []int, val int) int {
	for i := 0; i < len(mappings); i = i + 3 {
		dest, source, len := mappings[i], mappings[i+1], mappings[i+2]

		if val >= dest && val <= dest+len-1 {
			diff := val - dest
			return source + diff
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

func (a Almanac) LocationToSeed(location int) int {
	humidity := getSource(a.humidityToLocation, location)
	temperature := getSource(a.temperatureToHumidity, humidity)
	light := getSource(a.lightToTemperature, temperature)
	water := getSource(a.waterToLight, light)
	fertilizer := getSource(a.fertilizerToWater, water)
	soil := getSource(a.soilToFertilizer, fertilizer)
	seed := getSource(a.seedsToSoil, soil)

	return seed
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

func rangeContains(rng []int, val int) bool {
	for i := 0; i < len(rng); i = i + 2 {
		start, l := rng[i], rng[i+1]
		end := start + l

		if start <= val && end >= val {
			return true
		}
	}
	return false
}

func TestTwo(t *testing.T) {
	input := utils.ReadInput(5)
	almanac := parseAlmanac(input)

	loc := 1

	for {
		seed := almanac.LocationToSeed(loc)

		if rangeContains(almanac.seeds, seed) {
			fmt.Println(loc)
			return
		}
		loc++
	}
}
