package utils

import "strconv"

func StringsToInts(arr []string) ([]int, error) {
	ints := []int{}

	for _, str := range arr {
		num, err := strconv.Atoi(str)

		if err != nil {
			return nil, err
		}

		ints = append(ints, num)
	}

	return ints, nil
}

func Pop[V comparable](arr []V) []V {
	if len(arr) == 0 {
		return arr
	}

	return arr[1:]
}
