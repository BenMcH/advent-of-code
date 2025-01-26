Intcode = Struct.new(:program, :pc, :halted, :inputs, :outputs, :relative_base, :memory, :waiting_for_input) do
  POSITION_MODE = 0
  IMMEDIATE_MODE = 1
  RELATIVE_MODE = 2

  def initialize(*)
    super

    if self.program.is_a? String
      self.program = self.program.strip.split(",").map(&:to_i)
    end

    self.reset
  end

  def noun = self.program[1]
  def verb = self.prgram[2]

  def reset
    self.pc = 0
    self.halted = false
    self.inputs = []
    self.outputs = []
    self.relative_base = 0
    self.memory = Hash.new do |hash, key|
      raise "Invalid memory address #{key}" if key < 0

      hash[key] = self.program[key] || 0
    end

    self.waiting_for_input = false
  end

  def peek
    self.memory[self.pc]
  end

  def take
    mem = peek
    self.pc += 1

    return mem
  end

  def send(num)
    self.inputs << num
  end

  def param(modes, output = false)
    mode = modes % 10
    new_mode = (modes - mode) / 10

    val = take

    if mode == POSITION_MODE && !output
      val = self.memory[val]
    elsif mode == RELATIVE_MODE
      val = self.memory[self.relative_base + val]
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

      c += self.relative_base if _modes == 2

      self.memory[c] = a + b
    when 2 # MULT
      take
      a, _modes = param(_modes)
      b, _modes = param(_modes)
      c = take

      c += self.relative_base if _modes == 2
      self.memory[c] = a * b
    when 3 # INPUT
      self.waiting_for_input = inputs.empty?

      unless self.waiting_for_input
        take
        val = inputs.shift

        mem_loc = take
        if _modes == 2
          mem_loc += self.relative_base
        end

        self.memory[mem_loc] = val
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

      c += self.relative_base if _modes == 2

      self.memory[c] = a < b ? 1 : 0
    when 8 # EQUALS
      take
      a, _modes = param(_modes)
      b, _modes = param(_modes)
      c = take

      c += self.relative_base if _modes == 2

      self.memory[c] = a == b ? 1 : 0
    when 9 # Adjust relative base
      take
      a, _modes = param(_modes)

      self.relative_base += a
    when 99
      self.halted = true
    else
      raise "Unknown opcode: #{opcode}"
    end
  end
end
