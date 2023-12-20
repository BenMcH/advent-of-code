package day19

import (
	"advent-of-code-2023/utils"
	"fmt"
	"strings"
	"testing"
)

const TEST_INPUT = `
px{a<2006:qkq,m>2090:A,rfg}
pv{a>1716:R,A}
lnx{m>1548:A,A}
rfg{s<537:gd,x>2440:R,A}
qs{s>3448:A,lnx}
qkq{x<1416:A,crn}
crn{x>2662:A,R}
in{s<1351:px,qqz}
qqz{s>2770:qs,m<1801:hdj,R}
gd{a>3333:R,R}
hdj{m>838:A,pv}

{x=787,m=2655,a=1222,s=2876}
{x=1679,m=44,a=2067,s=496}
{x=2036,m=264,a=79,s=2244}
{x=2461,m=1339,a=466,s=291}
{x=2127,m=1623,a=2188,s=1013}
`

type Part [4]int

var PART_INDEXES = map[byte]int{'x': 0, 'm': 1, 'a': 2, 's': 3}

func parseParts(input string) []Part {
	lines := utils.Lines(input)
	arr := make([]Part, len(lines))

	for i, line := range lines {
		numbers := utils.NumbersFromString(line)
		arr[i] = Part{numbers[0], numbers[1], numbers[2], numbers[3]}
	}

	return arr
}

type RuleFunc func(p Part) (bool, string)

type RuleParams struct {
	validate  RuleFunc
	variable  byte
	operation byte
	num       int64
	target    string
}

type Ruleset map[string][]RuleParams

func parseRuleset(input string) Ruleset {
	rs := make(Ruleset)
	lines := utils.Lines(input)

	for _, line := range lines {
		line, _ := strings.CutSuffix(line, "}")
		ruleParams := make([]RuleParams, 0)
		sections := strings.Split(line, "{")

		ruleList := strings.Split(sections[1], ",")

		for _, ruleStr := range ruleList {
			if strings.Contains(ruleStr, ":") {
				parts := strings.Split(ruleStr, ":")
				target := parts[1]
				ch, op := parts[0][0], parts[0][1]
				num := utils.NumbersFromString(parts[0])

				rule := func(p Part) (bool, string) {
					val := p[PART_INDEXES[ch]]

					if op == '>' {
						if val > num[0] {
							return true, target
						}
					} else {
						if val < num[0] {
							return true, target
						}
					}

					return false, ""
				}

				params := RuleParams{
					validate:  rule,
					variable:  ch,
					operation: op,
					num:       int64(num[0]),
					target:    target,
				}

				ruleParams = append(ruleParams, params)
			} else {
				params := RuleParams{
					validate: func(p Part) (bool, string) { return true, ruleStr },
					target:   ruleStr,
				}
				ruleParams = append(ruleParams, params)
			}
		}

		rs[sections[0]] = ruleParams
	}

	return rs
}

func PartOne(input string) int {
	sections := strings.Split(input, "\n\n")
	ruleset := parseRuleset(sections[0])
	parts := parseParts(sections[1])

	sum := 0

	startKey := "in"

	for _, part := range parts {
		key := startKey
		for key != "R" && key != "A" {
			rules := ruleset[key]

			for _, rule := range rules {
				if matched, next := rule.validate(part); matched {
					key = next
					break
				}
			}
		}

		if key == "A" {
			for _, num := range part {
				sum += num
			}
		}
	}

	return sum
}

func TestPartOne(t *testing.T) {
	got := PartOne(TEST_INPUT)
	expected := 19114

	if got != expected {
		t.Error("Wrong", got, "Expected", expected)
		return
	}

	fmt.Println(PartOne(utils.ReadInput(19)))
}

type Range struct {
	start, end int64
}

func (r Range) Copy() Range {
	return Range{
		start: r.start,
		end:   r.end,
	}
}

type Combos [4]Range

func (c Combos) Combinations() int64 {
	var product int64 = 1

	for _, cmb := range c {
		product *= cmb.end - cmb.start + 1
	}

	return product
}

func CountCombinations(rules Ruleset, combo Combos, node string) int64 {
	if node == "A" {
		return combo.Combinations()
	}

	var sum int64 = 0
	for _, rule := range rules[node] {
		if rule.num == 'R' {
			continue
		}

		index := PART_INDEXES[rule.variable]
		rng := combo[index].Copy()

		if rule.operation == '>' && rng.start < rule.num {
			rng.start = rule.num + 1
			combo[index].end = rule.num
		}
		if rule.operation == '<' && rng.end > rule.num {
			rng.end = rule.num - 1
			combo[index].start = rule.num
		}

		var newCombos Combos = [4]Range{}
		for i, _range := range combo {
			if i == index {
				newCombos[i] = rng
			} else {
				newCombos[i] = _range
			}
		}

		sum += CountCombinations(rules, newCombos, rule.target)
	}

	return sum
}

func PartTwo(input string) int64 {
	sections := strings.Split(input, "\n\n")
	ruleset := parseRuleset(sections[0])

	var combo Combos = [4]Range{}

	for i := range combo {
		combo[i] = Range{
			start: 1,
			end:   4000,
		}
	}

	return CountCombinations(ruleset, combo, "in")
}

func TestPartTwo(t *testing.T) {
	got := PartTwo(TEST_INPUT)
	var expected int64 = 167409079868000

	if got != expected {
		t.Error("Wrong", got, "Expected", expected, "Diff", got-expected)
	}

	fmt.Println(PartTwo(utils.ReadInput(19)))
}
