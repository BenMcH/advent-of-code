# frozen_string_literal: true
require 'net/http'
require_relative "helpers/version"

# Constants
ALPHABET = ('a'..'z').to_a

# AOC Interaction
def get_input(year, day, session)
  input = if File.exists?('./input')
    File.read('./input')
  else
    puts "Requesting"
    res = Net::HTTP.get_response(URI("https://adventofcode.com/#{year}/day/#{day}/input"), {Cookie: "session=#{session}", "User-Agent" => "Ben McHone <ben@mchone.dev>"})
    body = res.body

    if body.strip == "Please don't repeatedly request this endpoint before it unlocks! The calendar countdown is synchronized with the server time; the link will be enabled on the calendar the instant this puzzle becomes available."
      throw Exception.new("Puzzle input not open")
    end

    File.write('./input', res.body)

    res.body
  end
end

# Strings
def lines(string)
  string.split("\n")
end

def characters(str_or_arr)
  if str_or_arr.is_a? String
    return str_or_arr.split('')
  else
    return str_or_arr.map{|line| characters(line)}
  end
end

def split_arr(arr, index)
  a, b = arr[0...index], arr[index..-1]
end

def is_upper(letter)
	letter == letter.upcase
end

def get_numbers(str)
  proc = Proc.new {|val| val.include?(".") ? val.to_f : val.to_i}

  str.scan(/-?\d+\.\d+|-?\d+/).map(&proc)
end

def overlaps?(one, other)
  one.cover?(other.first) || other.cover?(one.first)
end

def add_number_arrays(arr, arr2)
  arr.map.with_index do |v, i|
    v + arr2[i]
  end
end
