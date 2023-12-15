package day15

import (
	"advent-of-code-2023/utils"
	"fmt"
	"strconv"
	"strings"
	"testing"
)

func hash(input string) (hash int) {
	var rHash rune
	for _, h := range input {
		rHash += h
		rHash *= 17
		rHash %= 256
	}

	return int(rHash)
}

func TestHash(t *testing.T) {
	if hash("HASH") != 52 {
		t.Error("Failed to hash HASH", hash("HASH"))
	}
}

func TestPartOne(t *testing.T) {
	input := `rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7`

	input = utils.ReadInput(15)
	input = strings.ReplaceAll(input, "\n", "")
	list := strings.Split(input, ",")

	sum := 0

	for _, str := range list {
		sum += hash(str)
	}

	fmt.Println(sum)
}

type Lens struct {
	label       string
	focalLength int
}

func TestPartTwo(t *testing.T) {
	input := `rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7`
	boxes := make([][]Lens, 256)

	for i := range boxes {
		boxes[i] = make([]Lens, 0)
	}

	input = utils.ReadInput(15)
	input = strings.ReplaceAll(input, "\n", "")
	list := strings.Split(input, ",")

	sum := 0

	for _, str := range list {
		if strings.Contains(str, "=") {
			label, strFocal, _ := strings.Cut(str, "=")
			focalLength, _ := strconv.Atoi(strFocal)
			lens := Lens{label, focalLength}
			h := hash(label)

			found := false
			for i, ch := range boxes[h] {
				if ch.label == label {
					boxes[h][i] = lens
					found = true
					break
				}
			}

			if !found {
				boxes[h] = append(boxes[h], lens)
			}
		} else if strings.Contains(str, "-") {
			label, _ := strings.CutSuffix(str, "-")
			h := hash(label)

			boxes[h] = utils.Filter(boxes[h], func(l Lens, i int) bool { return l.label != label })
		} else {
			panic(str)
		}
	}

	for i, box := range boxes {
		for j, lens := range box {
			power := i + 1
			power *= j + 1
			power *= lens.focalLength
			sum += power
		}
	}

	fmt.Println(sum)
}
