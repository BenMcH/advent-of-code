package utils

import (
	"fmt"
	"io"
	"net/http"
	"os"
	"strings"
)

const YEAR = 2019

func ReadFile(path string) string {
	bytes, err := os.ReadFile(path)

	if err != nil {
		panic(err)
	}

	return strings.Trim(string(bytes), "\n")
}

func ReadInput(day int) string {
	_, err := os.Stat("./input.txt")

	if err != nil {
		client := &http.Client{}

		req, err := http.NewRequest("GET", fmt.Sprintf("https://adventofcode.com/%d/day/%d/input", YEAR, day), nil)

		if err != nil {
			panic(err)
		}

		cookie := http.Cookie{
			Name:  "session",
			Value: ReadFile("../.adventofcode.cookie"),
		}

		fmt.Println(cookie)

		req.AddCookie(&cookie)

		resp, err := client.Do(req)

		if err != nil {
			panic(err)
		}

		data, _ := io.ReadAll(resp.Body)

		str := string(data)

		if strings.Trim(str, " \n") == "Please don't repeatedly request this endpoint before it unlocks! The calendar countdown is synchronized with the server time; the link will be enabled on the calendar the instant this puzzle becomes available." {
			panic("Question not yet open. Cool your jets")
		}

		os.WriteFile("./input.txt", data, 0644)
	}

	return ReadFile("./input.txt")
}
