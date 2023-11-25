package utils

import (
	"reflect"
	"testing"
)

func TestTranspose(t *testing.T) {
	arr := [][]int {{1, 2}, {3, 4}}
	expected := [][]int {{1, 3}, {2, 4}}

	got := Transpose(arr)


	if !reflect.DeepEqual(expected, got) {
		t.Errorf("Expected: %v, got: %v", expected, got)
	}
}


func TestTransposeOddDimensions(t *testing.T) {
	arr := [][]int {{1, 2, 3}, {4, 5, 6}}
	expected := [][]int {{1,4}, {2, 5}, {3, 6}}

	got := Transpose(arr)


	if !reflect.DeepEqual(expected, got) {
		t.Errorf("Expected: %v, got: %v", expected, got)
	}
}
