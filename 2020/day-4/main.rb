# Split passport data into 2d array. First dimension: Passports, Second dimension: Properties
passport_data = File.read("./data.txt").split("\n\n").map(&:split)

valid_passports_pt_1 = passport_data.select do |passport|
    fields = passport.map{|field| field[0..2]}

    ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"].all? {|field| fields.include? field}
end

puts valid_passports_pt_1.length

valid_passports_pt_2 = valid_passports_pt_1.select do |passport|
    fields = passport.map{|field| [field[0..2], field[4..-1]]}

    fields.all? do |key, value|
        case key
        when 'byr'
            (1920..2002).include? value.to_i
        when 'iyr'
            (2010..2020).include? value.to_i
        when 'eyr'
            (2020..2030).include? value.to_i
        when 'hgt'
            unit = value[-2..-1]
            value = value[0..-2].to_i
            unit == 'cm' ? (150..193).include?(value) : (59..76).include?(value)
        when 'hcl'
            /^#[0-9a-f]{6}$/.match(value)
        when 'ecl'
            ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth'].include?(value)
        when 'pid'
            /^\d{9}$/.match(value)
        else
            true
        end
    end
end

puts valid_passports_pt_2.length
