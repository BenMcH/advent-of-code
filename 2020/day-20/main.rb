data = File.read('./data.txt').split("\n\n")

tiles = []

Tile = Struct.new :id, :edges, :tile_rows
tile_edges = {}
data.each do |t|
    name, *tt = t.split("\n")

    key = name[5..-2].to_i
    edges = [
        tt[0],
        tt[-1],
        tt.map{|c| c[0]}.join,
        tt.map{|c| c[-1]}.join,
    ]
    edges.concat edges.map(&:reverse)
    tiles << Tile.new(key, edges, tt)
end

c = tiles.map do |tile_entry|
    [
        tile_entry.id,
        tile_entry.edges[0..3].map{|edge| tiles.flat_map{|c| c.edges}.count{|c| c == edge}}.select{|c| c == 1}.length
    ]
end.select{|c| c[1] == 2}

p c.map{|b|b[0]}.reduce(&:*)
