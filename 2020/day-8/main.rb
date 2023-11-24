instructions = File.read('data.txt').split("\n").map(&:split).map{|instruction| [instruction[0].to_sym, instruction[1].to_i]}


def execute(program)
    run_instructions = []
    acc = 0
    program_counter = 0

    while program_counter < program.length && !run_instructions.include?(program_counter)
        instruction, argument = program[program_counter]
        run_instructions << program_counter

        case instruction
        when :acc
            acc += argument
        when :jmp
            program_counter += argument
            next
        end

        program_counter += 1
    end

    [acc, program_counter]
end

puts execute(instructions)[0]

instructions.each.with_index do |line, index|
    instruction, arg = line
    next unless [:jmp, :nop].include?(instruction)

    instructions[index][0] = instruction == :jmp ? :nop : :jmp
    acc, program_counter = execute(instructions)
    if (program_counter >= instructions.length)
        puts acc
    end
    instructions[index][0] = instruction
end
