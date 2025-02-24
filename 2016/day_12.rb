RubyVM::YJIT.enable

Computer = Struct.new(:instructions) do
  def initialize(input)
    self.instructions = input.split("\n").map do |line|
      line.split.map.with_index do |part, i|
        if part.match(/-?\d+/)
          part.to_i
        else
          part.to_sym
        end
      end
    end
  end

  def run(c = 0, a = 0)
    pc = 0
    a, b, c, d = a, 0, c, 0
    get = Proc.new do |i|
      if i.is_a? Integer
        i
      else
        case i
        when :a then a
        when :b then b
        when :c then c
        when :d then d
        end
      end
    end

    set = Proc.new do |i, v|
      case i
      when :a then a = v
      when :b then b = v
      when :c then c = v
      when :d then d = v
      end
    end

    while pc < instructions.length
      inst = instructions[pc]
      inst_1 = instructions[pc + 1]
      inst_2 = instructions[pc + 2]
      inst_3 = instructions[pc + 3]
      inst_4 = instructions[pc + 4]

      if inst == [:inc, :a] && inst_1 == [:dec, :c] && inst_2 == [:jnz, :c, -2] && inst_3 == [:dec, :d] && inst_4 == [:jnz, :d, -5]
        a += c * d
        c = 0
        d = 0
        pc += 5
        next
      end

      arg0 = inst[1]
      arg1 = inst[2]

      case inst[0]
      when :cpy
        set.call(arg1, get.call(arg0))
      when :inc
        set.call(arg0, get.call(arg0) + 1)
      when :dec
        set.call(arg0, get.call(arg0) - 1)
      when :jnz
        arg0 = get.call(arg0)
        arg1 = get.call(arg1)

        if arg0 != 0
          pc += arg1 - 1
        end
      when :tgl
        arg0 = get.call(arg0)

        if pc + arg0 >= 0 && pc + arg0 < instructions.length
          instruction = instructions[pc + arg0]

          if instruction.length == 2
            instruction[0] = instruction[0] == :inc ? :dec : :inc
          else
            instruction[0] = instruction[0] == :jnz ? :cpy : :jnz
          end
        end
      end

      pc += 1
    end

    return a
  end
end

if __FILE__ == $0
  c = Computer.new(File.read("./resources/input-12"))

  puts "Part 1: #{c.run(0)}"

  puts "Part 2: #{c.run(1)}"
end
