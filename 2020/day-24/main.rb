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

white = false
black = true

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
end

tiles = Hash.new(white)

starting_tile = Tile.new(0, 0)

instructions.each do |line|
  loc = starting_tile
  #tiles[loc] = !tiles[loc]
  parse_instructions(line).each do |inst|
    loc = loc.send(inst)
  end
  tiles[loc] = !tiles[loc]
end

p tiles.values.count(black)

