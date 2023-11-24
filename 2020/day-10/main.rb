jolts = File.read('./data.txt').split("\n").map(&:to_i).sort

differences = jolts.map.with_index { |jolt, index| index > 0 && jolt - jolts[index-1] || jolt }
one_jolt_differences = differences.count{|diff| diff == 1}
three_jolt_differences = differences.count{|diff| diff == 3} + 1 # For your device

p one_jolt_differences * three_jolt_differences

def fill_graph(parent, graph, jolts)
    (graph[parent] = jolts.select{|j| (1..3).include?(j - parent)}).each{|jolt| fill_graph(jolt, graph, jolts.select{|j| j > jolt}) } unless graph[parent]
end

def count_possibilities(graph_a, number, memo = {})
    memo[number] ||= number == graph_a[-1][0] ? 1 : graph_a.find{|a| a[0] == number}[1].map{|a| count_possibilities(graph_a, a, memo)}.sum
end

graph = {}
fill_graph(0, graph, jolts)
p count_possibilities(graph.to_a, 0)


