# frozen_string_literal: true
require "dotenv/load"
require "net/http"
require "fileutils"

class AdventOfCodeHelpers
  # Constants
  ALPHABET = ("a".."z").to_a

  # AOC Interaction
  def self.get_input(day)
    file_name = "./inputs/day#{day}.txt"
    if File.exist?(file_name)
      File.read(file_name)
    else
      puts "Requesting input from adventofcode.com"
      res = Net::HTTP.get_response(URI("https://adventofcode.com/#{ENV["AOC_YEAR"] || 2024}/day/#{day}/input"), { Cookie: "session=#{ENV["AOC_SESSION"]}", "User-Agent" => "Ben McHone <ben@mchone.dev>" })
      body = res.body

      if body.strip == "Please don't repeatedly request this endpoint before it unlocks! The calendar countdown is synchronized with the server time; the link will be enabled on the calendar the instant this puzzle becomes available."
        throw Exception.new("Puzzle input not open")
      end

      FileUtils.mkdir_p(File.dirname(file_name))
      File.write(file_name, body)

      body
    end
  end

  def self.can_submit?(day, level)
    file_name = "./inputs/day-#{day}-#{level}.txt"
    if File.exist?(file_name)
      return false
    end

    body = Net::HTTP.get(URI("https://adventofcode.com/#{ENV["AOC_YEAR"] || 2024}/day/#{day}"), { Cookie: "session=#{ENV["AOC_SESSION"]}", "User-Agent" => "Ben McHone <ben@mchone.dev>" })

    if body.include?("name=\"level\" value=\"#{level}\"")
      return true
    end

    File.write(file_name, body)

    return false
  end

  def self.submit_answer(day, answer, level)
    file_name = "./inputs/day-#{day}-#{level}.txt"

    unless can_submit?(day, level)
      return
    end

    puts "Submit Day #{day}, Level #{level}: #{answer}?"

    a = gets.chomp

    if a[0].downcase != "y"
      return
    end

    res = Net::HTTP.post(URI("https://adventofcode.com/#{ENV["AOC_YEAR"] || 2024}/day/#{day}/answer"), "level=#{level}&answer=#{answer}", { Cookie: "session=#{ENV["AOC_SESSION"]}", "User-Agent" => "Ben McHone <ben@mchone.dev>" })

    # Status will be 200 whether or not the answer is correct. We must check the body. The response is in a <main><article> tag.
    body = res.body

    if body.include?("That's not the right answer")
      File.write("./inputs/error.html", body)
      raise Exception.new("Incorrect answer")
    end

    if body.include?("You gave an answer too recently")
      raise Exception.new("Too soon")
    end

    if body.include?("That's the right answer")
      puts "Correct! Finished Part #{level}"
      File.write("./inputs/day-#{day}-#{level}.txt", answer)
    end
  end

  # Strings
  def self.lines(string)
    string.split("\n")
  end

  def self.characters(str_or_arr)
    if str_or_arr.is_a? String
      return str_or_arr.split("")
    else
      return str_or_arr.map { |line| characters(line) }
    end
  end

  def self.split_arr(arr, index)
    [
      arr[0...index],
      arr[index..-1],
    ]
  end

  def self.is_upper(letter)
    letter == letter.upcase
  end

  def self.get_numbers(str)
    proc = Proc.new { |val| val.include?(".") ? val.to_f : val.to_i }

    str.scan(/-?\d+\.\d+|-?\d+/).map(&proc)
  end

  def self.overlaps?(one, other)
    one.cover?(other.first) || other.cover?(one.first)
  end

  def self.add_number_arrays(arr, arr2)
    arr.map.with_index do |v, i|
      v + arr2[i]
    end
  end

  def self.rotate_ccw(arr)
    arr.transpose.reverse
  end

  def self.rotate_cw(arr)
    arr.transpose
  end
end
