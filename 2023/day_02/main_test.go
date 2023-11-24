package day02

import "testing"

func TestFunc() string {
	return "Hello world"
}

func TestTestFunc(t *testing.T) {
	got := TestFunc()

	if got != "Hello World!"{
		t.Errorf("Got: %s, expected: \"Hello World!\"", got)
	}
}
