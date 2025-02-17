input = File.read('./resources/input-16').strip.chars.map { |c| c == '1'}

def dragon_curve(arr)
	b = arr.reverse.map { |b| !b }
	[*arr, false, *b]
end


raise if dragon_curve([true]) != [true, false, false]

def checksum(arr)
	sum = arr.each_slice(2).map do |a,b|
		a == b
	end
	
	if sum.length & 1 == 0
		checksum(sum)
	else
		sum.map { |b| b ? "1" : "0" }.join
	end
end

disk_size = 272

curve = dragon_curve(input)

curve = dragon_curve(curve) until curve.length >= disk_size

curve = curve[0...disk_size]

puts checksum(curve)

disk_size = 35651584

curve = dragon_curve(input)

curve = dragon_curve(curve) until curve.length >= disk_size

curve = curve[0...disk_size]

puts checksum(curve)
