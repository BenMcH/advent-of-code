package day_02

import (
	"advent-of-code-2019/intcode"
	"advent-of-code-2019/utils"
	"strings"
)

func PartOne(code string) (int, error) {
	args := strings.Split(code, ",")
	ints, _ := utils.StringsToInts(args)

	ints[1] = 12
	ints[2] = 2
	ints, _ = intcode.ExecuteIntcode(ints)

	return ints[0], nil
}
