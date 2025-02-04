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

	def run(c = 0)
		pc = 0
		a, b, c, d = 0, 0, c, 0
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

				if arg0 != 0
					pc += arg1 - 1
				end
			end

			pc += 1
		end

		return a
	end
end

c = Computer.new(File.read("./resources/input-12"))

puts "Part 1: #{c.run(0)}"

puts "Part 2: #{c.run(1)}"
