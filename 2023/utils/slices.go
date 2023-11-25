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

func Transpose[V comparable](arr [][]V) [][]V {
	rows := len(arr)
	cols := len(arr[0])

	newArr := make([][]V, cols)
	for i := 0; i < cols; i++ {
		newArr[i] = make([]V, rows)
	}

	for i := 0; i < rows; i++ {
		for j := 0; j < cols; j++ {
			newArr[j][i] = arr[i][j]
		}
	}

	return newArr
}
