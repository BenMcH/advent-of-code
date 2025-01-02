class Day05
  def self.part_1(input)
    new_input = input.strip
    loop do
      ("a".."z").each do |char|
        new_input = new_input.gsub("#{char}#{char.upcase}", "")
        new_input = new_input.gsub("#{char.upcase}#{char}", "")
      end

      return new_input.length if new_input == input

      input = new_input
    end
  end

  def self.part_2(input)
    return 0
  end
end
