package utils

import "math"

func GCD(m, n int) int {
	if n == 0 {
		return m
	} else {
		return GCD(n, m%n)
	}
}

func LCM(m, n int) int {
	return m * n / GCD(m, n)
}

func IntPow(num, power int) int {
	return int(math.Pow(float64(num), float64(power)))
}
