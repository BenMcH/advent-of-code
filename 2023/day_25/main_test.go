package day25

import (
	"advent-of-code-2023/utils"
	"fmt"
	"strings"
	"testing"

	"github.com/twmb/algoimpl/go/graph"
)

func makeGraph(input string) (*graph.Graph, map[graph.Node]string) {
	output := graph.New(graph.Undirected)
	allNodes := make(map[string]graph.Node)
	nodesToStrs := make(map[graph.Node]string)
	for _, line := range utils.Lines(input) {
		left, right, _ := strings.Cut(line, ": ")
		nodes := strings.Split(right, " ")

		if _, ok := allNodes[left]; !ok {
			allNodes[left] = output.MakeNode()
			nodesToStrs[allNodes[left]] = left
		}
		for _, node := range nodes {
			if _, ok := allNodes[node]; !ok {
				allNodes[node] = output.MakeNode()
				nodesToStrs[allNodes[node]] = node
			}

			output.MakeEdge(allNodes[left], allNodes[node])
		}
	}

	return output, nodesToStrs //, strsToNodes
}

func countClusters(m *graph.Graph, nodeToStr map[graph.Node]string) []int {
	sizes := make([]int, 0)
	seen := utils.Set[string]{}

	for k, v := range nodeToStr {
		if seen.Has(v) {
			continue
		}

		sizes = append(sizes, 0)

		queue := []graph.Node{}
		queue = append(queue, m.Neighbors(k)...)
		seen.Add(v)
		sizes[len(sizes)-1]++

		for len(queue) > 0 {
			item := queue[0]
			queue = queue[1:]
			str := nodeToStr[item]
			if seen.Has(str) {
				continue
			}

			seen.Add(str)
			sizes[len(sizes)-1]++
			queue = append(queue, m.Neighbors(item)...)
		}
	}

	return sizes
}

func partOne(input string) int {
	m, nodeStrMap := makeGraph(input)

	edges := m.RandMinimumCut(1000, 10)

	for _, edge := range edges {
		m.RemoveEdge(edge.Start, edge.End)
	}

	sizes := countClusters(m, nodeStrMap)
	product := 1

	for _, size := range sizes {
		product *= size
	}

	return product
}

func TestPartOne(t *testing.T) {
	got := partOne(`jqt: rhn xhk nvd
rsh: frs pzl lsr
xhk: hfx
cmg: qnr nvd lhk bvb
rhn: xhk bvb hfx
bvb: xhk hfx
pzl: lsr hfx nvd
qnr: nvd
ntq: jqt hfx bvb xhk
nvd: lhk
lsr: lhk
rzs: qnr cmg lsr rsh
frs: qnr lhk lsr
`)

	if got != 54 {
		t.Error("Wrong", got, "Expected 54")
		return
	}

	fmt.Println(partOne(utils.ReadInput(25)))
}
