require "spec"
require "../helpers"

describe AdventOfCodeHelpers do
  describe ".lines" do
    it "splits a string by newlines" do
      input = "line1\nline2\nline3"
      result = AdventOfCodeHelpers.lines(input)
      result.should eq ["line1", "line2", "line3"]
    end

    it "handles single line" do
      input = "single line"
      result = AdventOfCodeHelpers.lines(input)
      result.should eq ["single line"]
    end

    it "handles empty string" do
      input = ""
      result = AdventOfCodeHelpers.lines(input)
      result.should eq [""]
    end
  end

  describe ".characters" do
    it "splits a string into characters" do
      input = "abc"
      result = AdventOfCodeHelpers.characters(input)
      result.should eq ["a", "b", "c"]
    end

    it "handles empty string" do
      input = ""
      result = AdventOfCodeHelpers.characters(input)
      result.should eq [] of String
    end

    it "splits an array of strings into array of character arrays" do
      input = ["ab", "cd"]
      result = AdventOfCodeHelpers.characters(input)
      result.should eq [["a", "b"], ["c", "d"]]
    end
  end

  describe ".split_arr" do
    it "splits array at given index" do
      arr = [1, 2, 3, 4, 5]
      result = AdventOfCodeHelpers.split_arr(arr, 3)
      result.should eq [[1, 2, 3], [4, 5]]
    end

    it "handles split at beginning" do
      arr = [1, 2, 3]
      result = AdventOfCodeHelpers.split_arr(arr, 0)
      result.should eq [[] of Int32, [1, 2, 3]]
    end

    it "handles split at end" do
      arr = [1, 2, 3]
      result = AdventOfCodeHelpers.split_arr(arr, 3)
      result.should eq [[1, 2, 3], [] of Int32]
    end
  end

  describe ".is_upper" do
    it "returns true for uppercase letter" do
      AdventOfCodeHelpers.is_upper("A").should be_true
    end

    it "returns false for lowercase letter" do
      AdventOfCodeHelpers.is_upper("a").should be_false
    end

    it "returns true for uppercase string" do
      AdventOfCodeHelpers.is_upper("ABC").should be_true
    end

    it "returns false for mixed case" do
      AdventOfCodeHelpers.is_upper("Abc").should be_false
    end
  end
  
  describe ".get_ints" do
	it "extracts integers from string" do
	  input = "abc 123 def 456"
	  result = AdventOfCodeHelpers.get_ints(input)
	  result.should eq [123, 456]
	end

	it "extracts negative integers" do
	  input = "value is -42"
	  result = AdventOfCodeHelpers.get_ints(input)
	  result.should eq [-42]
	end

	it "returns empty array when no integers" do
	  input = "no numbers here"
	  result = AdventOfCodeHelpers.get_ints(input)
	  result.should eq [] of Int32
	end
  end

  describe ".get_numbers" do
    it "extracts integers from string" do
      input = "abc 123 def 456"
      result = AdventOfCodeHelpers.get_numbers(input)
      result.should eq [123.0, 456.0]
    end

    it "extracts negative numbers" do
      input = "value is -42"
      result = AdventOfCodeHelpers.get_numbers(input)
      result.should eq [-42.0]
    end

    it "extracts floats" do
      input = "pi is 3.14"
      result = AdventOfCodeHelpers.get_numbers(input)
      result.should eq [3.14]
    end

    it "extracts mixed integers and floats" do
      input = "values: 10, 3.5, -2.7, 100"
      result = AdventOfCodeHelpers.get_numbers(input)
      result.should eq [10.0, 3.5, -2.7, 100.0]
    end

    it "returns empty array when no numbers" do
      input = "no numbers here"
      result = AdventOfCodeHelpers.get_numbers(input)
      result.should eq [] of Float64
    end
  end

  describe ".overlaps?" do
    it "returns true when first range covers start of second" do
      one = 1..5
      other = 3..7
      AdventOfCodeHelpers.overlaps?(one, other).should be_true
    end

    it "returns true when second range covers start of first" do
      one = 5..10
      other = 3..7
      AdventOfCodeHelpers.overlaps?(one, other).should be_true
    end

    it "returns true when ranges are identical" do
      one = 5..10
      other = 5..10
      AdventOfCodeHelpers.overlaps?(one, other).should be_true
    end

    it "returns false when ranges don't overlap" do
      one = 1..3
      other = 5..10
      AdventOfCodeHelpers.overlaps?(one, other).should be_false
    end

    it "returns true when one range contains the other" do
      one = 1..10
      other = 3..7
      AdventOfCodeHelpers.overlaps?(one, other).should be_true
    end
  end

  describe ".add_number_arrays" do
    it "adds corresponding elements" do
      arr1 = [1, 2, 3]
      arr2 = [4, 5, 6]
      result = AdventOfCodeHelpers.add_number_arrays(arr1, arr2)
      result.should eq [5, 7, 9]
    end

    it "works with negative numbers" do
      arr1 = [10, -5, 3]
      arr2 = [-2, 15, -3]
      result = AdventOfCodeHelpers.add_number_arrays(arr1, arr2)
      result.should eq [8, 10, 0]
    end

    it "works with floats" do
      arr1 = [1.5, 2.5]
      arr2 = [0.5, 1.5]
      result = AdventOfCodeHelpers.add_number_arrays(arr1, arr2)
      result.should eq [2.0, 4.0]
    end
  end

  describe ".rotate_ccw" do
    it "rotates 2D array counter-clockwise" do
      arr = [
        [1, 2, 3],
        [4, 5, 6],
      ]
      result = AdventOfCodeHelpers.rotate_ccw(arr)
      result.should eq [
        [3, 6],
        [2, 5],
        [1, 4],
      ]
    end

    it "rotates square matrix counter-clockwise" do
      arr = [
        [1, 2],
        [3, 4],
      ]
      result = AdventOfCodeHelpers.rotate_ccw(arr)
      result.should eq [
        [2, 4],
        [1, 3],
      ]
    end
  end

  describe ".rotate_cw" do
    it "rotates 2D array clockwise" do
      arr = [
        [1, 2, 3],
        [4, 5, 6],
      ]
      result = AdventOfCodeHelpers.rotate_cw(arr)
      result.should eq [
        [4, 1],
        [5, 2],
        [6, 3],
      ]
    end

    it "rotates square matrix clockwise" do
      arr = [
        [1, 2],
        [3, 4],
      ]
      result = AdventOfCodeHelpers.rotate_cw(arr)
      result.should eq [
        [3, 1],
        [4, 2],
      ]
    end
  end

  describe "ALPHABET" do
    it "contains all lowercase letters" do
      AdventOfCodeHelpers::ALPHABET.should eq ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    end

    it "has 26 letters" do
      AdventOfCodeHelpers::ALPHABET.size.should eq 26
    end
  end
end
