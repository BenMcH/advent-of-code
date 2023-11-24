test_input = File.read('./test-input.txt')
real_input = File.read('./input')

TreeItem = Struct.new(
	:parent,
	:name,
	:children,
	:type,
	:size,

	keyword_init: true
)

def change_dir(line, current_dir, root_dir)
	dir = line[5..-1]

	if dir == '/'
		return root_dir
	elsif dir == '..'
		return current_dir.parent
	else
		dir = current_dir.children.find{|dir| dir.name == dir}
		if !dir
				dir = TreeItem.new(
					name: dir,
					parent: current_dir,
					type: 'dir',
					children: []
				)

				current_dir.children << dir
		end

		dir
	end
end

def size_dir(dir)
	dir.children.map do |entry|
		if entry.type == 'dir'
			size_dir(entry)
		else
			entry.size
		end
	end.sum
end

def size_big_dirs(tree)
	total_size = 0

	return total_size if tree.type == 'file'

	size = size_dir(tree)

	if size <= 100000
		total_size += size
	end

	tree&.children.each do |child|
		total_size += size_big_dirs(child)
	end

	total_size
end

def map_directory_tree(input)
	root_dir = TreeItem.new(
		parent: nil,
		name: '/',
		children: [],
		type: 'dir'
	)

	current_dir = root_dir

	input.lines.each do |line|
		line = line.strip
		if line.start_with? "$"
			if line.start_with? "$ cd"
				current_dir = change_dir(line, current_dir, root_dir)
			end
		else # ls items
			is_dir = line.start_with? "dir"
			if is_dir
				change_dir(line, current_dir, root_dir)
			else
				size, name = *line.split(' ')
				current_dir.children << TreeItem.new(
					name: name,
					size: size.to_i,
					parent: current_dir,
					children: [],
					type: 'file'
				)
			end
		end
	end

	root_dir
end

def get_tree(tree)
	res = {
		name: tree.name,
		type: tree.type,
		children: {},
		size: tree.size
	}

	tree.children.each do |t|
		res[:children][t.name] = get_tree(t)
	end

	res
end

def find_deletion_candidates(tree, min_file_size, candidates = [])
	size = size_dir(tree)
	if size > min_file_size
		candidates << size

		tree.children.filter{|c| c.type == 'dir'}.each do |f|
			find_deletion_candidates(f, min_file_size, candidates)
		end
	end

	candidates
end

def solution_part_1(input)
	tree = map_directory_tree(input)

	return size_big_dirs(tree)
end

def solution_part_2(input)
	tree = map_directory_tree(input)

	total_fs_size = 70000000
	required_size = 30000000
	min_file_size = required_size - (total_fs_size - size_dir(tree))

	candidates = find_deletion_candidates(tree, min_file_size)

	return candidates.min
end

describe "Day 7" do
	
	it "Part 1 should pass" do
		expect(solution_part_1(test_input)).to eq(95437)

		p "Part 1: #{solution_part_1(real_input)}"
	end

	it "Part 2 should pass" do
		expect(solution_part_2(test_input)).to eq(24933642)
		p "Part 2: #{solution_part_2(real_input)}"
	end
end
