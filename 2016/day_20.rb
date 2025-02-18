nums = File.read('./resources/input-20').scan(/\d+/).map(&:to_i)

ranges = []

nums.each_slice(2) do |a, b|
	ranges << (a..b)
end

ranges.sort_by! { |r| r.begin }

n = 0

enc = ranges[0]

while enc
	n = enc.end + 1
	enc = ranges.find { |r| r.include? n }
end

p n
