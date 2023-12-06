package day05

import (
	"advent-of-code-2023/utils"
	"fmt"
	"math"
	"strings"
	"testing"
)

type Almanac struct {
	seeds      []int
	seedRanges []RangeMapping
	filters    [][]RangeMapping
}

type RangeMapping struct {
	source      Range
	destination Range
}

type Range struct {
	start, end int
}

func (a Almanac) Reflow() Almanac {
	newAlmanac := Almanac{
		seedRanges: ReflowRanges(a.seedRanges, a.filters[0]),
		filters:    make([][]RangeMapping, len(a.filters)),
	}

	copy(newAlmanac.filters, a.filters)

	for x := 0; x < 4; x++ {
		for i, filter := range newAlmanac.filters {
			if i == len(a.filters)-1 {
				newAlmanac.filters[i] = filter
			} else {
				newAlmanac.filters[i] = ReflowRanges(newAlmanac.filters[i], newAlmanac.filters[i+1])
			}
		}
	}

	return newAlmanac
}

func ReflowRanges(inputs []RangeMapping, mappings []RangeMapping) []RangeMapping {
	newArr := make([]RangeMapping, 0)

	for len(inputs) > 0 {
		input := inputs[0]
		inputs = inputs[1:]

		for _, mapping := range mappings {
			if input.source.start < mapping.source.start && input.source.end > mapping.source.start {
				// Overlaps bottom half
				rng := Range{input.source.start, mapping.source.start - 1}
				newArr = append(newArr, RangeMapping{rng, rng})
				if input.source.end < mapping.source.end {
					rng := Range{mapping.source.start, input.source.end}
					newArr = append(newArr, RangeMapping{rng, rng})
				} else if input.source.end == mapping.source.end {
					rng := Range{mapping.source.start, mapping.source.end}
					newArr = append(newArr, RangeMapping{rng, rng})
				} else {
					rng := Range{mapping.source.start, mapping.source.end}
					newArr = append(newArr, RangeMapping{rng, rng})
					rng = Range{mapping.source.end + 1, input.source.end}
					newArr = append(newArr, RangeMapping{rng, rng})
				}
			} else if input.source.start >= mapping.source.start && input.source.end <= mapping.source.end {
				// Completely contained - Do we just keep the range? Let's try it.
				newArr = append(newArr, input)
			} else if input.source.start >= mapping.source.start && input.source.end > mapping.source.end {
				// Extends above range
				rng := Range{input.source.start, mapping.source.end}
				newArr = append(newArr, RangeMapping{rng, rng})
				rng = Range{mapping.source.end + 1, input.source.end}
				newArr = append(newArr, RangeMapping{rng, rng})
			}
		}
	}

	return newArr
}

func TestRangeReflow(t *testing.T) {
	rng := Range{0, 10}
	mapping := RangeMapping{
		source:      Range{5, 15},
		destination: Range{0, 10},
	}

	got := ReflowRanges([]RangeMapping{{rng, rng}}, []RangeMapping{mapping})

	if len(got) != 2 {
		t.Errorf("Expected length to be 2. Got: %d", len(got))
	}

	// if !slices.Contains(got, Range{0, 4}) || !slices.Contains(got, Range{5, 10}) {
	// 	t.Errorf("Expected {0, 4} and {5, 10}. Got: %v", got)
	// }

	rng = Range{10, 20}
	mapping.source = Range{0, 50}
	got = ReflowRanges([]RangeMapping{{rng, rng}}, []RangeMapping{mapping})

	if len(got) != 1 {
		t.Errorf("Expected length to be 1. Got: %d", len(got))
	}

	// if !slices.Contains(got, Range{10, 20}) {
	// 	t.Errorf("Expected {10, 20}. Got: %v", got)
	// }

	rng = Range{10, 20}
	mapping.source = Range{0, 15}
	got = ReflowRanges([]RangeMapping{{rng, rng}}, []RangeMapping{mapping})

	if len(got) != 2 {
		t.Errorf("Expected length to be 2. Got: %d", len(got))
	}

	// if !slices.Contains(got, Range{10, 15}) || !slices.Contains(got, Range{16, 20}) {
	// 	t.Errorf("Expected {10, 15} and {16, 20}. Got: %v", got)
	// }

	rng = Range{10, 100}
	mapping.source = Range{50, 60}
	mapping.destination = Range{150, 160}

	got = ReflowRanges([]RangeMapping{{rng, rng}}, []RangeMapping{mapping})

	if len(got) != 3 {
		t.Errorf("Expected length to be 3. Got: %d", len(got))
	}

	// if !slices.Contains(got, Range{10, 49}) || !slices.Contains(got, Range{50, 60}) || !slices.Contains(got, Range{61, 100}) {
	// 	t.Errorf("Expected {10, 49}, {50, 60} {61, 100}. Got: %v", got)
	// }

	fmt.Println(got)
}

func ParseRanges(input []int) []RangeMapping {
	arr := make([]RangeMapping, 0)

	for i := 0; i < len(input); i = i + 3 {
		arr = append(arr, RangeMapping{
			source: Range{
				start: input[i+1],
				end:   input[i+1] + input[i+2] - 1,
			},
			destination: Range{
				start: input[i],
				end:   input[i] + input[i+2] - 1,
			},
		})
	}
	return arr
}

func parseAlmanac(input string) Almanac {
	almanac := Almanac{}

	sections := strings.Split(input, "\n\n")
	almanac.seeds = utils.NumbersFromString(sections[0])
	almanac.seedRanges = make([]RangeMapping, 0)

	for i := 0; i < len(almanac.seeds); i = i + 2 {
		start, len := almanac.seeds[i], almanac.seeds[i+1]

		rng := Range{start: start, end: start + len - 1}
		almanac.seedRanges = append(almanac.seedRanges, RangeMapping{
			source:      rng,
			destination: rng,
		})
	}

	almanac.filters = make([][]RangeMapping, 0)
	almanac.filters = append(almanac.filters, ParseRanges(utils.NumbersFromString(sections[1])))
	almanac.filters = append(almanac.filters, ParseRanges(utils.NumbersFromString(sections[2])))
	almanac.filters = append(almanac.filters, ParseRanges(utils.NumbersFromString(sections[3])))
	almanac.filters = append(almanac.filters, ParseRanges(utils.NumbersFromString(sections[4])))
	almanac.filters = append(almanac.filters, ParseRanges(utils.NumbersFromString(sections[5])))
	almanac.filters = append(almanac.filters, ParseRanges(utils.NumbersFromString(sections[6])))
	almanac.filters = append(almanac.filters, ParseRanges(utils.NumbersFromString(sections[7])))

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
	val := seed

	for _, filter := range a.filters {
		val = getDestination(filter, val)
	}

	return val
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

const TEST_INPUT = `seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4
`

func TestTwo(t *testing.T) {
	input := TEST_INPUT
	almanac := parseAlmanac(input).Reflow()

	least := math.MaxInt

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

	for _, rng := range almanac.seedRanges {
		min := min(almanac.SeedToLocation(rng.source.start), almanac.SeedToLocation(rng.source.end))

		fmt.Println(min)

		if min < least {
			least = min
		}
	}

	if least != 46 {
		t.Errorf("Expected 46; Got: %d", least)
	}
}

// func getDestinationRanges(mappings []RangeMapping, val int) int {
// 	for _, rangeMapping := range mappings {

// 		if val >= rangeMapping.source.start && val <= rangeMapping.source.end {
// 			diff := val - rangeMapping.source.start
// 			return rangeMapping.destination.start + diff
// 		}
// 	}

// 	return val
// }
