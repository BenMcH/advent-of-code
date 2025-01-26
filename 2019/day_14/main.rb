Conversion = Struct.new(:inputs, :output_type, :output_num) do
	def self.parse(line)
		input, output = line.split(" => ").map(&:strip)

		input = input.split(", ").reduce({}) do |h, entry|
			num = entry[/\d+/].to_i
			h.merge(entry[/[A-Z]+/].to_sym => num)
		end

		output_num = output[/\d+/].to_i
		output_type = output[/[A-Z]+/].to_sym

		new(input, output_type, output_num)
	end
end

conversions = File.readlines("./input.txt").map(&:strip).map(&Conversion.method(:parse))

output_map = conversions.reduce({}) do |h, conv|
	raise if h[conv.output_type]
	h.merge(conv.output_type => conv)
end

def count_ore_for_conversion(conv, output_map, amount_needed = 1, excess = Hash.new(0))
  reactions_needed = ((amount_needed - excess[conv.output_type]).to_f / conv.output_num).ceil
  
  if reactions_needed <= 0
    excess[conv.output_type] -= amount_needed
    return 0
  end
  
  produced = reactions_needed * conv.output_num
  excess[conv.output_type] += produced - amount_needed
  
  conv.inputs.map do |input, num|
    total_input_needed = num * reactions_needed
    if input == :ORE
      total_input_needed
    else
      count_ore_for_conversion(output_map[input], output_map, total_input_needed, excess)
    end
  end.sum
end

fuel = output_map[:FUEL]

p count_ore_for_conversion(fuel, output_map)
