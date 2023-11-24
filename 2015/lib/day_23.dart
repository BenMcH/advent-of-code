enum InstructionType {
  hlf("hlf"),
  inc("inc"),
  jmp("jmp"),
  jie("jie"),
  jio("jio"),
  tpl("tpl"),
  nop("nop"),
  ;

  const InstructionType(this.opcode);

  final String opcode;
}

class Instruction {
  InstructionType opcode = InstructionType.nop;
  String? register;
  int? arg;

  Instruction(this.opcode, this.register, this.arg);

  Instruction.parse(String input) {
    var args = input.split(' ');
    assert(args.length > 1);

    opcode = InstructionType.values.firstWhere(
        (element) => element.opcode == args[0],
        orElse: () => InstructionType.nop);

    if (opcode == InstructionType.jmp) {
      arg = int.tryParse(args[1]);
    } else {
      register = args[1];
      arg = args.length > 2 ? int.tryParse(args[2]) : null;
    }
  }

  @override
  String toString() {
    return "${opcode.opcode} $register $arg";
  }
}

class Computer {
  Map<String, int> registers = {'a': 0, 'b': 0};
  List<Instruction> instructions;
  int pointer = 0;

  Computer(this.instructions);

  @override
  String toString() {
    return "registers: $registers; pointer: $pointer";
  }

  void runTilEnd() {
    var oldPointer = pointer;

    do {
      oldPointer = pointer;
      step();
    } while (oldPointer != pointer);
  }

  void step() {
    if (pointer < 0 || pointer >= instructions.length) return;

    var instruction = instructions[pointer];

    switch (instruction.opcode) {
      case InstructionType.hlf:
        registers[instruction.register!] =
            registers[instruction.register!]! ~/ 2;
        break;
      case InstructionType.tpl:
        registers[instruction.register!] =
            registers[instruction.register!]! * 3;
        break;
      case InstructionType.inc:
        registers[instruction.register!] =
            registers[instruction.register!]! + 1;
        break;
      case InstructionType.nop:
        break;
      case InstructionType.jie:
        var reg = registers[instruction.register!]!;

        if (reg % 2 == 0) {
          pointer += instruction.arg ?? 0;
          return;
        }
        break;
      case InstructionType.jio:
        var reg = registers[instruction.register!]!;

        if (reg == 1) {
          pointer += instruction.arg ?? 0;
          return;
        }

        break;
      case InstructionType.jmp:
        pointer += instruction.arg ?? 0;
        return;
    }

    pointer += 1;
  }
}
