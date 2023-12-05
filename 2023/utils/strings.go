package utils

import "strings"

func Lines(input string) []string {
	return strings.Split(strings.Trim(input, "\n"), "\n")
}
