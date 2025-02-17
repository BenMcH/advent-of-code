num_elves = File.read('./resources/input-19').strip.to_i

LinkedList = Struct.new(:elf, :next_elf) do
	def to_s
		"#{elf}"
	end
	
	def steal!
		self.next_elf = self.next_elf.next_elf
	end
	
	def steal_across!(num_elves)
		dist = num_elves / 2

		elf = self
		(dist - 1).times { elf = elf.next_elf }

		elf.steal!
	end
end

first = LinkedList.new(1, nil)

last = first

(2..num_elves).each do |i|
	last.next_elf = LinkedList.new(i, nil)
	last = last.next_elf
end

last.next_elf = first

elf = first

until elf.next_elf == elf
	elf.steal!

	elf = elf.next_elf
end

puts elf

first = LinkedList.new(1, nil)
last = first
mid = first

(2..num_elves).each do |i|
	last.next_elf = LinkedList.new(i, nil)
	last = last.next_elf
	
	mid = last if i == num_elves / 2
end

last.next_elf = first

elf = first

until elf.next_elf == elf
	mid.steal!

	num_elves -= 1

	mid = mid.next_elf if num_elves % 2 == 0
	elf = elf.next_elf
end

puts elf
