package day22

import (
	"advent-of-code-2023/utils"
	"cmp"
	"fmt"
	"math"
	"slices"
	"strings"
	"testing"
)

const TEST_INPUT = `1,0,1~1,2,1
0,0,2~2,0,2
0,2,3~2,2,3
0,0,4~0,2,4
2,0,5~2,2,5
0,1,6~2,1,6
1,1,8~1,1,9
`

type Vec3 struct {
	x, y, z int
}

type Block struct {
	start, end *Vec3
}

func (b Block) overlaps(b2 Block) bool {
	xOverlaps := max(b.start.x, b2.start.x) <= min(b.end.x, b2.end.x)
	yOverlaps := max(b.start.y, b2.start.y) <= min(b.end.y, b2.end.y)

	return xOverlaps && yOverlaps
}

func readBlocks(input string) (arr []Block, maxVec Vec3) {
	lines := utils.Lines(input)

	arr = make([]Block, 0)

	minVec := Vec3{x: math.MaxInt, y: math.MaxInt, z: math.MaxInt}
	for _, line := range lines {
		nums := strings.Split(line, "~")
		vecs := [2]Vec3{}

		for i, n := range nums {
			nums := utils.NumbersFromString(n)

			vec := Vec3{x: nums[0], y: nums[1], z: nums[2] - 1} // make this 0 indexed for easier array ops
			vecs[i] = vec

			maxVec.x = max(maxVec.x, vec.x)
			maxVec.y = max(maxVec.y, vec.y)
			maxVec.z = max(maxVec.z, vec.z)
			minVec.x = min(minVec.x, vec.x)
			minVec.y = min(minVec.y, vec.y)
			minVec.z = min(minVec.z, vec.z)

		}
		arr = append(arr, Block{
			start: &vecs[0],
			end:   &vecs[1],
		})
	}

	slices.SortFunc(arr, func(a, b Block) int {
		return cmp.Compare(a.start.z, b.start.z)

	})

	return arr, maxVec
}

func fall(blocks []Block) []Block {
	for i, block := range blocks {
		minZ := 0
		for _, otherBlock := range blocks[:i] {
			if block.overlaps(otherBlock) {
				minZ = max(minZ, otherBlock.end.z+1)
			}
		}
		block.end.z -= (block.start.z - minZ)
		block.start.z = minZ
	}

	slices.SortFunc(blocks, func(a, b Block) int {
		return cmp.Compare(a.start.z, b.start.z)

	})

	return blocks
}

func PartOne(input string) int {
	blocks, _ := readBlocks(input)

	blocks = fall(blocks)
	supportsList := make(map[int][]int)
	supportedByList := make(map[int][]int)

	for i := range blocks {
		supportsList[i] = make([]int, 0)
		supportedByList[i] = make([]int, 0)
	}

	for i, topBrick := range blocks {
		for j, lowerBrick := range blocks[:i] {
			if topBrick.overlaps(lowerBrick) && lowerBrick.end.z == topBrick.start.z-1 {
				supportsList[j] = append(supportsList[j], i)
				supportedByList[i] = append(supportedByList[i], j)
			}
		}

	}

	total := 0

	for i := range blocks {
		allSupported := true
		for _, j := range supportsList[i] {
			if len(supportedByList[j]) < 2 {
				allSupported = false
			}
		}

		if allSupported {
			total++
		}
	}

	return total
}

func TestPartOne(t *testing.T) {
	got := PartOne(TEST_INPUT)
	expected := 5

	if got != expected {
		fmt.Println("Wrong", got, "expected", expected)
		return
	}

	fmt.Println(PartOne(utils.ReadInput(22)))
}
