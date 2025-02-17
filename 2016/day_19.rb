num_elves = File.read('./resources/input-19').strip.to_i

LinkedList = Struct.new(:elf, :next_elf) do
	def to_s
		"#{elf}"
	end
	
	def steal!
		self.next_elf = self.next_elf.next_elf
	end
end

first = LinkedList.new(1, nil)
last = first

first_p2 = LinkedList.new(1, nil)
last_p2 = first_p2
mid_p2 = first_p2


(2..num_elves).each do |i|
	last.next_elf = LinkedList.new(i, nil)
	last = last.next_elf

	last_p2.next_elf = LinkedList.new(i, nil)
	last_p2 = last_p2.next_elf
	mid_p2 = last_p2 if i == num_elves / 2
end

last.next_elf = first
last_p2.next_elf = first_p2

elf = first
elf_p2 = first_p2

until elf.next_elf == elf
	elf.steal!
	mid_p2.steal!

	num_elves -= 1
	mid_p2 = mid_p2.next_elf if num_elves % 2 == 0

	elf = elf.next_elf
	elf_p2 = elf_p2.next_elf
end

puts elf
puts elf_p2
