package day20

import (
	"advent-of-code-2023/utils"
	"fmt"
	"strings"
	"testing"
)

const (
	HIGH_PULSE = true
	LOW_PULSE  = false
)

/*
broadcaster -> a, b, c
%a -> b
%b -> c
%c -> inv
&inv -> a

*/

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
		/*
			Conjunction modules (prefix &) remember the type of the most recent pulse received
			from each of their connected input modules; they initially default to remembering a
			low pulse for each input. When a pulse is received, the conjunction module first updates
			its memory for that input. Then, if it remembers high pulses for all inputs,
			it sends a low pulse; otherwise, it sends a high pulse.
		*/

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

func PartOne(input string) int {
	data := parseInput(input)

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
				// fmt.Println(signal.source, "-high->", signal.dest)
				high++
			} else {
				// fmt.Println(signal.source, "-low->", signal.dest)
				low++
			}

			destination := data[signal.dest]
			// fmt.Println(destination)

			newSignals := destination.sendPulse(signal.source, signal.value)
			// data[signal.dest] = destination // Why is this needed??

			queue = append(queue, newSignals...)
		}
	}

	fmt.Println(low, high)
	return low * high
}

func TestPartOne(t *testing.T) {
	got := PartOne(`broadcaster -> a
%a -> inv, con
&inv -> b
%b -> con
&con -> output
`)
	if got != 11687500 {
		t.Error("Wrong", got, "Expected", 11687500)
		return
	}

	fmt.Println(PartOne(utils.ReadInput(20)))
}
