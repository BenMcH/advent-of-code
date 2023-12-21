package day20

import (
	"advent-of-code-2023/utils"
	"fmt"
	"slices"
	"strings"
	"testing"
)

const (
	HIGH_PULSE = true
	LOW_PULSE  = false
)

type Module struct {
	name         string
	typeStr      string
	destinations []string
	value        bool // Used for flip flop
	memory       map[string]bool
}

func (m *Module) sendPulse(source string, pulse bool) []Signal {
	signals := make([]Signal, 0)

	if m == nil {
		return signals
	}

	if m.typeStr == "B" { // Broadcaster
		for _, dest := range m.destinations {
			signals = append(signals, Signal{
				source: m.name,
				dest:   dest,
				value:  pulse,
			})
		}
	} else if m.typeStr == "%" { // Flip Flop
		if pulse == HIGH_PULSE {
			return signals
		}
		m.value = !m.value

		for _, dest := range m.destinations {
			signals = append(signals, Signal{
				source: m.name,
				dest:   dest,
				value:  m.value,
			})
		}
	} else if m.typeStr == "&" { // Conjunction
		m.memory[source] = pulse
		allHigh := true

		for _, v := range m.memory {
			allHigh = allHigh && v == HIGH_PULSE
		}

		pulseToSend := LOW_PULSE
		if !allHigh {
			pulseToSend = HIGH_PULSE
		}

		for _, dest := range m.destinations {
			signals = append(signals, Signal{
				source: m.name,
				dest:   dest,
				value:  pulseToSend,
			})
		}
	}

	return signals
}

func parseInput(input string) map[string]*Module {
	lines := utils.Lines(input)
	modules := make(map[string]*Module, len(lines))

	modules["output"] = &Module{
		typeStr:      "O",
		name:         "output",
		destinations: make([]string, 0),
		memory:       map[string]bool{},
	}

	for i, line := range lines {
		line = strings.ReplaceAll(line, " -> ", " ")
		line = strings.ReplaceAll(line, ",", "")
		lines[i] = line

		entities := strings.Split(line, " ")
		moduleName, entities := entities[0], entities[1:]
		mod := Module{
			name:         moduleName,
			typeStr:      "B",
			destinations: entities,
			memory:       make(map[string]bool),
		}

		if moduleName != "broadcaster" {
			mod.typeStr = string(moduleName[0])
			mod.name = moduleName[1:]
		}

		modules[mod.name] = &mod
	}

	for _, module := range modules {
		for _, dest := range module.destinations {
			destinationModule, ok := modules[dest]

			if !ok {
				continue
			}

			destinationModule.memory[module.name] = LOW_PULSE
		}
	}

	return modules
}

type Signal struct {
	source string
	dest   string
	value  bool
}

func PartOne(data map[string]*Module) int {
	low, high := 0, 0

	var signal Signal
	for x := 0; x < 1000; x++ {
		queue := make([]Signal, 0)

		queue = append(queue, Signal{
			source: "button",
			dest:   "broadcaster",
			value:  LOW_PULSE,
		})
		for len(queue) > 0 {
			signal, queue = queue[0], queue[1:]

			if signal.value == HIGH_PULSE {
				high++
			} else {
				low++
			}

			destination := data[signal.dest]
			newSignals := destination.sendPulse(signal.source, signal.value)
			queue = append(queue, newSignals...)
		}
	}

	return low * high
}

func TestPartOne(t *testing.T) {
	data := parseInput(`broadcaster -> a
%a -> inv, con
&inv -> b
%b -> con
&con -> output
`)
	got := PartOne(data)
	if got != 11687500 {
		t.Error("Wrong", got, "Expected", 11687500)
		return
	}

	data = parseInput(utils.ReadInput(20))

	fmt.Println(PartOne(data))
}

func PartTwo(data map[string]*Module) int {
	targets := []string{"lk", "fn", "fh", "hh"} // 4 conjunctions leading to end
	periods := []int{0, 0, 0, 0}                // Track the period at which this input goes high

	x := 1
	for {
		var signal Signal
		queue := make([]Signal, 0)

		queue = append(queue, Signal{
			source: "button",
			dest:   "broadcaster",
			value:  LOW_PULSE,
		})
		for len(queue) > 0 {
			signal, queue = queue[0], queue[1:]

			if slices.Contains(targets, signal.source) && signal.value == HIGH_PULSE {
				index := slices.Index(targets, signal.source)
				if periods[index] == 0 {
					periods[index] = x
				}

				p := 1

				for _, val := range periods {
					p *= val
				}

				if p > 0 { // A 0 period (not found) will result in a 0 p value
					return p
				}
			}

			destination := data[signal.dest]
			newSignals := destination.sendPulse(signal.source, signal.value)
			queue = append(queue, newSignals...)
		}
		x++
	}
}

func TestPartTwo(t *testing.T) {
	data := parseInput(utils.ReadInput(20))

	fmt.Println(PartTwo(data))
}
