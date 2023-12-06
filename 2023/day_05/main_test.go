package day05

import (
	"advent-of-code-2023/utils"
	"fmt"
	"strings"
	"testing"
)

type Almanac struct {
	seeds                 []int
	seedRanges            []Range
	seedsToSoil           []RangeMapping
	soilToFertilizer      []RangeMapping
	fertilizerToWater     []RangeMapping
	waterToLight          []RangeMapping
	lightToTemperature    []RangeMapping
	temperatureToHumidity []RangeMapping
	humidityToLocation    []RangeMapping
}

type RangeMapping struct {
	source      Range
	destination Range
}

type Range struct {
	start, end int
}

func ParseRanges(input []int) []RangeMapping {
	arr := make([]RangeMapping, 0)

	for i := 0; i < len(input); i = i + 3 {
		arr = append(arr, RangeMapping{
			source: Range{
				start: input[i+1],
				end:   input[i+1] + input[i+2],
			},
			destination: Range{
				start: input[i],
				end:   input[i] + input[i+2],
			},
		})
	}
	return arr
}

func parseAlmanac(input string) Almanac {
	almanac := Almanac{}

	sections := strings.Split(input, "\n\n")
	almanac.seeds = utils.NumbersFromString(sections[0])
	almanac.seedRanges = make([]Range, 0)

	for i := 0; i < len(almanac.seeds); i = i + 2 {
		start, len := almanac.seeds[i], almanac.seeds[i+1]

		almanac.seedRanges = append(almanac.seedRanges, Range{
			start: start,
			end:   start + len,
		})
	}
	almanac.seedsToSoil = ParseRanges(utils.NumbersFromString(sections[1]))
	almanac.soilToFertilizer = ParseRanges(utils.NumbersFromString(sections[2]))
	almanac.fertilizerToWater = ParseRanges(utils.NumbersFromString(sections[3]))
	almanac.waterToLight = ParseRanges(utils.NumbersFromString(sections[4]))
	almanac.lightToTemperature = ParseRanges(utils.NumbersFromString(sections[5]))
	almanac.temperatureToHumidity = ParseRanges(utils.NumbersFromString(sections[6]))
	almanac.humidityToLocation = ParseRanges(utils.NumbersFromString(sections[7]))

	return almanac
}

func getDestination(mappings []RangeMapping, val int) int {
	for _, rangeMapping := range mappings {

		if val >= rangeMapping.source.start && val <= rangeMapping.source.end {
			diff := val - rangeMapping.source.start
			return rangeMapping.destination.start + diff
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

func TestTwo(t *testing.T) {
	input := utils.ReadInput(5)
	almanac := parseAlmanac(input)

	least := almanac.SeedToLocation(1) // 999999999

	// for i := 0; i < len(almanac.seeds); i = i + 2 {
	// 	start, l := almanac.seeds[i], almanac.seeds[i+1]
	// 	target := start + l
	// 	for seed := start; seed <= target; seed++ {
	// 		loc := almanac.SeedToLocation(seed)

	// 		if loc < least {
	// 			least = loc
	// 		}
	// 	}
	// }

	fmt.Println(least)
}
