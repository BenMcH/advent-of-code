class Day03
  def self.part_1(input)
    # mul(n,n)
    multipliciations = input.scan(/mul\(\d+,\d+\)/)

    products = multipliciations.map do |str|
      a, b = str.scan(/\d+/)

      a.to_i * b.to_i
    end

    return products.sum
  end

  def self.part_2(input)
    instructions = input.scan(/mul\(\d+,\d+\)|do\(\)|don't\(\)/)
    enabled = true

    products = []

    instructions.each do |instruction|
      if instruction == "do()"
        enabled = true
        next
      end

      if instruction == "don't()"
        enabled = false
        next
      end

      unless enabled
        next
      end

      a, b = instruction.scan(/\d+/)
      products << a.to_i * b.to_i
    end

    return products.sum
  end
end
