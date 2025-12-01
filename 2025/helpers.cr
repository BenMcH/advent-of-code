require "dotenv"
require "http/client"

Dotenv.load

class AdventOfCodeHelpers
  ALPHABET = ("a".."z").to_a

  def self.get_input(day : Int32)
    file_name = "./resources/day#{day}.txt"
    if File.exists?(file_name)
      File.read(file_name)
    else
      puts "Requesting input from adventofcode.com"
      year = ENV["AOC_YEAR"]? || "2025"
      session = ENV["AOC_SESSION"]?
      headers = HTTP::Headers{"Cookie" => "session=#{session}", "User-Agent" => "Ben McHone <ben@mchone.dev>"}
      res = HTTP::Client.get("https://adventofcode.com/#{year}/day/#{day}/input", headers: headers)
      body = res.body

      if body.strip == "Please don't repeatedly request this endpoint before it unlocks! The calendar countdown is synchronized with the server time; the link will be enabled on the calendar the instant this puzzle becomes available."
        raise "Puzzle input not open"
      end

      Dir.mkdir_p(File.dirname(file_name))
      File.write(file_name, body)

      body
    end
  end

  def self.can_submit?(day : Int32, level : Int32) : Bool
    file_name = "./resources/day-#{day}-#{level}.txt"
    if File.exists?(file_name)
      return false
    end

    year = ENV["AOC_YEAR"]? || "2025"
    session = ENV["AOC_SESSION"]?
    headers = HTTP::Headers{"Cookie" => "session=#{session}", "User-Agent" => "Ben McHone <ben@mchone.dev>"}
    body = HTTP::Client.get("https://adventofcode.com/#{year}/day/#{day}", headers: headers).body

    if body.includes?("name=\"level\" value=\"#{level}\"")
      return true
    end

    unless level == 2 && body.includes?("name=\"level\" value=\"1\"")
      File.write(file_name, body)
    end

    false
  end

  def self.submit_answer(day : Int32, answer : String, level : Int32)
    unless can_submit?(day, level)
      return
    end

    puts "Submit Day #{day}, Level #{level}: #{answer}?"

    a = gets.try &.chomp
    return unless a

    if a[0].downcase != 'y'
      return
    end

    year = ENV["AOC_YEAR"]? || "2025"
    session = ENV["AOC_SESSION"]?
    headers = HTTP::Headers{"Cookie" => "session=#{session}", "User-Agent" => "Ben McHone <ben@mchone.dev>"}
    res = HTTP::Client.post("https://adventofcode.com/#{year}/day/#{day}/answer", body: "level=#{level}&answer=#{answer}", headers: headers)

    body = res.body

    if body.includes?("That's not the right answer")
      File.write("./resources/error.html", body)
      raise "Incorrect answer"
    end

    if body.includes?("You gave an answer too recently")
      raise "Too soon"
    end

    if body.includes?("That's the right answer")
      puts "Correct! Finished Part #{level}"
      File.write("./resources/day-#{day}-#{level}.txt", answer)
    end
  end

  def self.lines(string : String)
    string.split('\n')
  end

  def self.characters(str_or_arr : String | Array(String))
    if str_or_arr.is_a?(String)
      str_or_arr.chars.map(&.to_s)
    else
      str_or_arr.map { |line| characters(line) }
    end
  end

  def self.split_arr(arr : Array(T), index : Int32) forall T
    [
      arr[0...index],
      arr[index..-1],
    ]
  end

  def self.upper?(letter : String)
    letter == letter.upcase
  end

  def self.get_ints(str : String) : Array(Int32)
    regex = /-?\d+/
    matches = [] of Int32
    str.scan(regex) do |int_match|
      s = int_match[0]
      matches << s.to_i32
    end
    matches
  end

  def self.get_numbers(str : String) : Array(Float64)
    regex = /-?\d+\.\d+|-?\d+/
    matches = [] of Float64
    str.scan(regex) do |float_match|
      s = float_match[0]
      matches << (s.includes?(".") ? s.to_f64 : s.to_f64)
    end
    matches
  end

  def self.overlaps?(one : Range(T, T), other : Range(T, T)) : Bool forall T
    one.covers?(other.begin) || other.covers?(one.begin)
  end

  def self.add_number_arrays(arr : Array(T), arr2 : Array(T)) : Array(T) forall T
    arr.map_with_index { |v, i| v + arr2[i] }
  end

  def self.rotate_ccw(arr : Array(Array(T))) forall T
    arr.transpose.reverse!
  end

  def self.rotate_cw(arr : Array(Array(T))) forall T
    arr.reverse.transpose
  end
end
