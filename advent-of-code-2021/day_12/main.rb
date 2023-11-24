def travel(routes, allow_double_visits, visited = {}, current_route = 'start', path = current_route, paths = [])
	visited[current_route] = visited[current_route].to_i + 1

	lower_routes = routes[current_route].filter{ |key| key == key.downcase && key != 'start' }
	lower_routes = lower_routes.filter{ |key| visited[key].nil? || allow_double_visits }

	valid_routes = routes[current_route].filter{ |key| key == key.upcase }.concat(lower_routes)

	if valid_routes.include? 'end'
		paths << path + ',end'
		valid_routes = valid_routes.filter { |route| route != 'end' }
	end

	valid_routes.each do |r|
		change = r.downcase == r ? allow_double_visits && !path.include?(r) : allow_double_visits
		travel(routes, change, visited.dup, r, "#{path},#{r}", paths)
	end

	return paths.length
end

def part_1(graph)
	travel(graph, false)
end

def build_graph(inputs)
	graph = {}
	inputs.each do |i|
		one, two = i

		(graph[one] ||= []) << two
		(graph[two] ||= []) << one
	end

	graph
end

example_input = File.read('example.txt').split("\n").map {|row| row.split('-')}
example_graph = build_graph(example_input)
ans = part_1(example_graph)

throw Exception.new("Part 1 is not 10, got: #{ans}" ) if 10 != ans

input = File.read('input.txt').split("\n").map {|row| row.split('-')}
input_graph = build_graph(input)

p part_1(input_graph)

def part_2(graph)
	travel(graph, true)
end

ans = part_2(example_graph)
throw Exception.new("Part 2 is not 36, got: #{ans}") if ans != 36

p part_2(input_graph)
