
Intcode = Struct.new(:program, :pc, :halted, :original_program) do
  
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
  end

  def peek = program[pc]
  def take
    mem = peek
    self.pc += 1

    return mem
  end

  def step
    return if halted

    opcode = peek
    self.pc += 1

    case opcode
      when 1 # ADD
        a = program[take]
        b = program[take]
        c = take
        self.program[c] = a + b
      when 2 # MULT
        a = program[take]
        b = program[take]
        c = take
        self.program[c] = a * b
      when 99
        self.halted = true
      else
        raise "Unknown opcode: #{opcode}"
    end
  end
end
