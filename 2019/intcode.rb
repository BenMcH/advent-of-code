Intcode = Struct.new(:program, :pc, :halted, :original_program, :inputs, :outputs) do
  POSITION_MODE = 0
  IMMEDIATE_MODE = 1

  def initialize(*)
    super

    if self.program.is_a? String
      self.original_program = self.program.split(",").map(&:to_i)
    end

    self.reset
  end

  def noun = self.program[1]
  def verb = self.prgram[2]

  def reset
    self.program = self.original_program.dup
    self.pc = 0
    self.halted = false
    self.inputs = []
    self.outputs = []
  end

  def peek
    self.program[self.pc]
  end

  def take
    mem = peek
    self.pc += 1

    return mem
  end

  def send(num)
    self.inputs << num
  end

  def param(modes)
    mode = modes % 10
    new_mode = (modes - mode) / 10

    val = take

    if mode == POSITION_MODE
      val = program[val]
    end

    return val, new_mode
  end

  def step
    return if halted

    mem = peek
    opcode = mem % 100
    _modes = (mem - opcode) / 100

    case opcode
    when 1 # ADD
      take
      a, _modes = param(_modes)
      b, _modes = param(_modes)
      c = take
      self.program[c] = a + b
    when 2 # MULT
      take
      a, _modes = param(_modes)
      b, _modes = param(_modes)
      c = take
      self.program[c] = a * b
    when 3 # INPUT
      if inputs.any?
        take
        val = inputs.shift

        self.program[take] = val
      end
    when 4 # OUTPUT
      take
      self.outputs << param(_modes)[0]
    when 5 # JUMP-IF-TRUE
      take
      a, _modes = param(_modes)
      b, _modes = param(_modes)

      if a != 0
        self.pc = b
      end
    when 6 # JUMP-IF-FALSE
      take
      a, _modes = param(_modes)
      b, _modes = param(_modes)

      if a == 0
        self.pc = b
      end
    when 7 # LESS-THAN
      take
      a, _modes = param(_modes)
      b, _modes = param(_modes)
      c = take

      self.program[c] = a < b ? 1 : 0
    when 8 # EQUALS
      take
      a, _modes = param(_modes)
      b, _modes = param(_modes)
      c = take

      self.program[c] = a == b ? 1 : 0
    when 99
      self.halted = true
    else
      raise "Unknown opcode: #{opcode}"
    end
  end
end
