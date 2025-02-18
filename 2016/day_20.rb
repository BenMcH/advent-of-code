nums = File.read('./resources/input-20').scan(/\d+/).map(&:to_i)

ranges = []

nums.each_slice(2) do |a, b|
	ranges << (a..b)
end

ranges.sort_by! { |r| r.begin }

n = 0

max = 2**32 - 1
count = 0
ips = []

loop do
	break if n > max

	enc = ranges.find { |r| r.include? n }
	
	if enc.nil?
		ips << n
		n += 1
		next
	end

	n = enc.end + 1
end

p ips[0]
p ips.length
