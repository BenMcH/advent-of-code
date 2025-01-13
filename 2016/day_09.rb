input = File.read('./resources/input-8')

def decompress(str, p2 = false)
  len = 0

  str = str.strip.chars

  str_pos = 0

  until str_pos == str.length
    ch = str[str_pos]
    unless ch == "("
      len += 1
      str_pos += 1
    else
      repeat_input = str[str_pos + 1..]
      end_i = repeat_input.index(")")

      repeat_input = repeat_input[0...end_i]
      cap, repeat = repeat_input.join().scan(/\d+/).map(&:to_i)

      str_pos += 2 + repeat_input.length

      if p2
        captured = str[str_pos...str_pos + cap].join
        _cap = decompress(captured, true)
        len += _cap * repeat
      else
        len += cap * repeat
      end
      str_pos += cap
    end

  end

  return len
end

p decompress(input)
p decompress(input, true)
