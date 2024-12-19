class Day17
  Computer = Struct.new(:a, :b, :c, :prog, :instruction_pointer, :halted)
  ADV = 0
  BXL = 1
  BST = 2
  JNZ = 3
  BXC = 4
  OUT = 5
  BDV = 6
  CDV = 7

  def self.combo(computer, operand)
    if (0..3).include?(operand)
      return operand
    elsif operand == 4
      return computer.a
    elsif operand == 5
      return computer.b
    elsif operand == 6
      return computer.c
    else
      raise "Invalid operand: #{operand}"
    end
  end

  def self.cycle(computer)
    if computer.instruction_pointer >= computer.prog.size
      return [], true
    end

    out = []

    op = computer.prog[computer.instruction_pointer]
    operand = computer.prog[computer.instruction_pointer + 1]

    case op
    when ADV
      computer.a /= (2 ** combo(computer, operand))
    when BXL
      computer.b = computer.b ^ operand
    when BST
      computer.b = combo(computer, operand) % 8
    when JNZ
      if computer.a != 0
        computer.instruction_pointer = operand - 2
      end
    when BXC
      computer.b = computer.b ^ computer.c
    when OUT
      out << combo(computer, operand) % 8
    when BDV
      computer.b = computer.a / (2 ** combo(computer, operand))
    when CDV
      computer.c = computer.a / (2 ** combo(computer, operand))
    end

    computer.instruction_pointer += 2

    return out, false
  end

  def self.part_1(input)
    a, b, c, *prog = input.scan(/\d+/).map(&:to_i)
    computer = Computer.new(a, b, c, prog, 0, false)

    out = []

    until computer.halted
      _out, computer.halted = cycle(computer)

      out += _out
    end

    out.join(",")
  end

  def self.part_2(input)
    a, b, c, *prog = input.scan(/\d+/).map(&:to_i)
    a = 8 ** (prog.size - 1)

    rev_prog = prog.reverse

    loop do
      computer = Computer.new(a, b, c, prog, 0, false)

      out = []

      until computer.halted
        _out, computer.halted = cycle(computer)
        out += _out
      end

      return a if out == prog

      pow = Math.log(a, 8).truncate

      out.reverse_each.with_index do |n, i|
        break unless rev_prog[i] == n
        pow -= 1
      end

      a += 8 ** pow
    end
  end
end
