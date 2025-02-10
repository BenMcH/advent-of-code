require 'set'
require 'digest'

salt = File.read("./resources/input-14").strip

def triple(str)
	str.chars.each_cons(3).find { |a,b,c| a == b && b == c }
end

def quintuple(str)
	str.chars.each_cons(5).find_all{ |a,b,c,d,e| a == b && b == c && c == d && d == e }
end

def hash(str, times = 0)
	str = Digest::MD5.hexdigest(str)
	times.times { str = Digest::MD5.hexdigest(str) }

	str	
end

i = 0

cache = {}

matches = Set.new

until matches.length >= 64
	h = hash(salt + i.to_s)

	cache[i] = h

	# t = triple(h)
	quints = quintuple(h)

	# p [t && t[0], f[0]]

	quints.each do |f|

		(1..1000).each do |j|
			num = i - j
			next if cache[num].nil?

			h = triple(cache[num])

			if h && h[0] == f[0]
				matches << num
			end
		end
	end

	i += 1
end


p matches.to_a.sort[63]

cache = {}
matches = Set.new
i = 0

until matches.length >= 64
	h = hash(salt + i.to_s, 2016)

	cache[i] = h

	# t = triple(h)
	quints = quintuple(h)

	# p [t && t[0], f[0]]

	quints.each do |f|

		(1..1000).each do |j|
			num = i - j
			next if cache[num].nil?

			h = triple(cache[num])

			if h && h[0] == f[0]
				matches << num
			end
		end
	end

	i += 1
end


p matches.to_a.sort[63]
