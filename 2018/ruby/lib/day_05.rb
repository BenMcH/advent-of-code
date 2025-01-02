class Day05
  def self.part_1(input)
    input.strip!
    loop do
      new_input = input
      input.chars.each_cons(2) do |a, b|
        if a != b && a.casecmp?(b)
          new_input = new_input.gsub("#{a}#{b}", "")
          new_input = new_input.gsub("#{b}#{a}", "")
        end
      end

      return new_input.length if new_input == input

      input = new_input
    end
  end

  def self.part_2(input)
    return 0
  end
end
