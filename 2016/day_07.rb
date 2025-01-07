input = File.readlines("./resources/input-7").map(&:strip)

def supports_tls(txt)
  in_brackets = false
  tls = false
  txt.chars.each_cons(4) do |a,b,c,d|
    if d == "["
      in_brackets = true
      next
    elsif d == "]"
      in_brackets = false
      next
    end

    if a == d && b == c && a != b
      return false if in_brackets
      tls = true
    end
  end

  return tls
end


p input.count { |i| supports_tls i }

def supports_ssl(txt)
  in_brackets = false
  in_arr = []
  out_arr = []
  txt.chars.each_cons(3) do |a,b,c|
    if c == "["
      in_brackets = true
      next
    elsif c == "]"
      in_brackets = false
      next
    end

    if a == c && a != b
      if in_brackets
        in_arr << "#{b}#{a}"

        return true if out_arr.include? in_arr[-1]
      else
        out_arr << "#{a}#{b}"
        return true if in_arr.include? out_arr[-1]
      end
    end
  end

  return false
end

p input.count { |i| supports_ssl i }
