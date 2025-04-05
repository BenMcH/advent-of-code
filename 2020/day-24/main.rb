instructions = File.readlines("./data.txt", chomp: true)

def parse_instructions(line)
  cache = ""
  parsed = []

  line.chars.each do |ch|
    # east, southeast, southwest, west, northwest, and northeast

    if ["e", "w"].include?(ch)
      parsed << "#{cache}#{ch}"
      cache = ""
    elsif ["n", "s"].include?(ch)
      cache << ch
    else
      raise "What is: #{ch}"
    end
  end

  parsed
end

@white = false
@black = true

Tile = Struct.new(:x, :y) do
  def e
    Tile.new(x+1, y)
  end

  def w
    Tile.new(x-1, y)
  end

  def se
    if y % 2 == 0
      Tile.new(x+1, y+1)
    else
      Tile.new(x, y+1)
    end
  end

  def sw
    if y % 2 == 0
      Tile.new(x, y+1)
    else
      Tile.new(x-1, y+1)
    end
  end

  def ne
    if y % 2 == 0
      Tile.new(x+1, y-1)
    else
      Tile.new(x, y-1)
    end
  end

  def nw
    if y % 2 == 0
      Tile.new(x, y-1)
    else
      Tile.new(x-1, y-1)
    end
  end

  def adjacent
    [e, w, ne, nw, se, sw]
  end
end

tiles = Hash.new(@white)

starting_tile = Tile.new(0, 0)

instructions.each do |line|
  loc = starting_tile
  #tiles[loc] = !tiles[loc]
  parse_instructions(line).each do |inst|
    loc = loc.send(inst)
  end
  if tiles[loc] == @black
    tiles.delete(loc)
  else
    tiles[loc] = @black
  end
end

p tiles.values.count(@black)

def flip(tiles)
  n_tiles = Hash.new(@white)
  check = tiles.keys.flat_map(&:adjacent).uniq

  check.each do |tile|
    neighbors = tile.adjacent.map { |t| tiles[t] }.tally
    n_tile = tiles[tile]
    if tiles[tile] == @black
      n_tile = @white if neighbors[@black] == 0 || neighbors[@black] > 2
    else
      n_tile = @black if neighbors[@black] == 2
    end
      n_tiles[tile] = @black if n_tile == @black
  end

  n_tiles
end

100.times do
  tiles = flip(tiles)
end

p tiles.length
