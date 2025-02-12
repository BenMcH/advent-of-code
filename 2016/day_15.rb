# Disc #1 has 7 positions; at time=0, it is at position 0.


Disc = Struct.new(:id, :positions, :_, :starting_position) do
	def open_at(time)
		(time + starting_position + id) % positions == 0
	end

	def to_s
		"Disc ##{id} has #{positions} positions; at time=#{time}, it is at position #{starting_position}."
	end
end

lines = File.readlines("./resources/input-15")

discs = lines.map do |line|
	nums = line.scan(/\d+/).map(&:to_i)
	Disc.new(*nums)
end

time = 0

until discs.all? { |disc| disc.open_at(time) }
	time += 1
end

puts time

last_disk = discs[-1]
discs << Disc.new(last_disk.id + 1, 11, nil, 0)

time = 0

until discs.all? { |disc| disc.open_at(time) }
	time += 1
end

puts time
