passwords = File.read('./data.txt').split("\n")

good_passwords_part_1 = passwords.select do |pass|
    start_limit, end_limit, letter, password = /(\d+)-(\d+)\s*(\w):\s*(\w+)/.match(pass).captures
    start_limit, end_limit = start_limit.to_i, end_limit.to_i
    password = password.gsub(/[^#{letter}]/, '')

    (start_limit..end_limit).include?(password.length)
end

puts good_passwords_part_1.length

good_passwords_part_2 = passwords.select do |pass|
    first_index, second_index, letter, password = /(\d+)-(\d+)\s*(\w):\s*(\w+)/.match(pass).captures
    first_index, second_index = first_index.to_i - 1, second_index.to_i - 1

    (password[first_index] == letter) ^ (password[second_index] == letter)
end

puts good_passwords_part_2.length
