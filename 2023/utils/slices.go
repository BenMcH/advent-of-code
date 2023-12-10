package utils

import (
	"regexp"
	"strconv"
)

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

func NumbersFromString(input string) []int {
	regex := regexp.MustCompile(`-?\d+`)

	strs := regex.FindAllString(input, -1)
	arr := make([]int, len(strs))

	for i, val := range strs {
		arr[i], _ = strconv.Atoi(val)
	}

	return arr
}

func SumIntArr(arr []int) (sum int) {
	for _, val := range arr {
		sum = sum + val
	}

	return
}

func Map[K any, V any](inputArr []K, f func(K, int) V) []V {
	arr := make([]V, len(inputArr))

	for i, item := range inputArr {
		arr[i] = f(item, i)
	}

	return arr
}

func Filter[V any](inputArr []V, f func(V, int) bool) []V {
	arr := make([]V, 0)

	for i, item := range inputArr {
		if f(item, i) {
			arr = append(arr, item)
		}
	}

	return arr
}

func Reduce[K any, V any](inputArr []K, initialValue V, f func(V, K) V) V {
	val := initialValue
	for _, item := range inputArr {
		val = f(val, item)
	}

	return val
}

func All[K any](inputArr []K, f func(K) bool) bool {
	for _, item := range inputArr {
		if !f(item) {
			return false
		}
	}

	return true
}

func Any[K any](inputArr []K, f func(K) bool) bool {
	for _, item := range inputArr {
		if f(item) {
			return true
		}
	}

	return false
}

func Count[K any](inputArr []K, f func(K) bool) int {
	count := 0
	for _, item := range inputArr {
		if f(item) {
			count++
		}
	}

	return count
}
