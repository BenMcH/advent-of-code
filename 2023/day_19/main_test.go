package day19

import (
	"advent-of-code-2023/utils"
	"fmt"
	"strings"
	"testing"
)

const TEST_INPUT = `px{a<2006:qkq,m>2090:A,rfg}
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

type Part struct {
	x, m, a, s int
}

func parseParts(input string) []Part {
	lines := utils.Lines(input)
	arr := make([]Part, len(lines))

	for i, line := range lines {
		numbers := utils.NumbersFromString(line)
		arr[i] = Part{
			x: numbers[0],
			m: numbers[1],
			a: numbers[2],
			s: numbers[3],
		}
	}

	return arr
}

type Rule func(p Part) (bool, string)

type Ruleset map[string][]Rule

func parseRuleset(input string) Ruleset {
	rs := make(Ruleset)

	// qqz{s>2770:qs,m<1801:hdj,R}
	lines := utils.Lines(input)

	for _, line := range lines {
		line, _ := strings.CutSuffix(line, "}")
		rules := make([]Rule, 0)
		sections := strings.Split(line, "{")

		ruleList := strings.Split(sections[1], ",")

		for _, ruleStr := range ruleList {
			if strings.Contains(ruleStr, ":") {
				parts := strings.Split(ruleStr, ":")
				target := parts[1]
				ch, op := parts[0][0], parts[0][1]
				num := utils.NumbersFromString(parts[0])

				rule := func(p Part) (bool, string) {
					val := 0
					if ch == 'x' {
						val = p.x
					} else if ch == 'm' {
						val = p.m
					} else if ch == 'a' {
						val = p.a
					} else if ch == 's' {
						val = p.s
					} else {
						panic(fmt.Sprintf("unknown char %s", string(ch)))
					}

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

				rules = append(rules, rule)
			} else {
				rules = append(rules, func(p Part) (bool, string) { return true, ruleStr })
			}
		}

		rs[sections[0]] = rules
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
				if matched, next := rule(part); matched {
					key = next
					break
				}
			}
		}

		if key == "A" {
			sum += (part.x + part.m + part.a + part.s)
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
