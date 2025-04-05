class Tile
  attr_reader :id, :grid, :edges, :all_possible_edges, :top, :bottom, :left, :right

  def to_s
    id
  end
  
  def initialize(id, grid)
    @id = id
    @grid = grid
    calculate_edges
  end
  
  def calculate_edges
    @top = @grid.first
    @bottom = @grid.last
    @left = @grid.map { |row| row[0] }.join
    @right = @grid.map { |row| row[-1] }.join
    
    @edges = [@top, @right, @bottom, @left]
    @all_possible_edges = @edges + @edges.map(&:reverse)
  end
  
  def connects_with?(other_tile)
    @all_possible_edges.any? { |edge| other_tile.all_possible_edges.include?(edge) }
  end
  
  def count_unique_edges(all_tiles)
    unique_count = 0
    
    @edges.each do |edge|
      matches = 0
      all_tiles.each do |tile|
        next if tile.id == @id
        matches += 1 if tile.all_possible_edges.include?(edge)
      end
      unique_count += 1 if matches == 0
    end

    unique_count
  end

  def neighbors(all_tiles)
    neighbors = []
    all_tiles.each do |other|
        next if other.id == @id

        neighbors << other if connects_with?(other)
    end

    neighbors
  end

  def rotate
    @grid = @grid.map(&:chars).transpose.map(&:reverse).map(&:join)
    calculate_edges
  end

  def flip
    @grid = @grid.map(&:reverse)
    calculate_edges
  end

  def all_orientations
    orientations = []

    2.times do
      4.times do
        orientations << self.dup
        rotate
      end
      flip
    end

    orientations
  end

  def dup
    Tile.new(@id, @grid.map(&:dup))
  end
end

def parse_input(filename)
  data = File.read(filename).split("\n\n")
  
  tiles = []
  data.each do |tile_data|
    lines = tile_data.split("\n")
    id = lines.first.match(/Tile (\d+):/)[1].to_i
    grid = lines[1..]
    
    tiles << Tile.new(id, grid)
  end
  
  tiles
end

def find_corner_tiles(tiles)
  corner_tiles = []
  
  tiles.each do |tile|

    if tile.count_unique_edges(tiles) == 2
      corner_tiles << tile
    end
  end
  
  corner_tiles
end

tiles = parse_input('./data.txt')
corners = find_corner_tiles(tiles)

p1 = corners.map(&:id).reduce(:*)

raise unless p1 == 108603771107737
p p1

size = Math.sqrt(tiles.size).to_i

arrs = []
size.times do
    arrs << [nil] * size
end

n_map = {}

tiles.each do |t|
    n_map[t] = t.neighbors(tiles)
end

n = n_map[corners[0]].flat_map(&:all_possible_edges)

c = corners[0].all_orientations.find do |c|
    n.include?(c.right) && n.include?(c.bottom)
end

arrs[0][0] = c

(1...size).each do |i|
    existing = arrs[i-1][0]

    options = existing.neighbors(tiles).flat_map(&:all_orientations)

    arrs[i][0] = options.find do |c|
        c.top == existing.bottom
    end

    existing = arrs[0][i-1]

    options = existing.neighbors(tiles).flat_map(&:all_orientations)

    arrs[0][i] = options.find do |c|
        c.left == existing.right
    end
end

(1...size).each do |i|
    (1...size).each do |j|
        existing_top = arrs[i-1][j]
        existing_left = arrs[i][j-1]

        neighbors_top = existing_top.neighbors(tiles)
        neighbors_left = existing_top.neighbors(tiles)

        options = neighbors_top.filter{|n| neighbors_left.include?(n)}.flat_map(&:all_orientations)

        opt = options.find do |c|
            c.top == existing_top.bottom && c.left == existing_left.right
        end

        arrs[i][j] = opt
        
    end
end

def strip_borders(tile)
  tile.grid[1...-1].map { |row| row[1...-1] }
end

def build_full_image(tile_grid)
  image_rows = []

  tile_grid.each do |tile_row|
    # Strip borders from each tile in the row
    stripped_tiles = tile_row.map { |tile| strip_borders(tile) }

    # Combine corresponding rows from each tile
    stripped_tiles[0].size.times do |i|
      image_rows << stripped_tiles.map { |tile| tile[i] }.join
    end
  end

  image_rows
end

SEA_MONSTER_PATTERN = [
  "                  # ",
  "#    ##    ##    ###",
  " #  #  #  #  #  #  "
]

SEA_MONSTER_OFFSETS = []

SEA_MONSTER_PATTERN.each_with_index do |row, y|
  row.chars.each_with_index do |char, x|
    SEA_MONSTER_OFFSETS << [y, x] if char == '#'
  end
end

def rotate_image(image)
  image.map(&:chars).transpose.map(&:reverse).map(&:join)
end

def flip_image(image)
  image.map(&:reverse)
end

def all_image_orientations(image)
  orientations = []
  2.times do
    4.times do
      orientations << image
      image = rotate_image(image)
    end
    image = flip_image(image)
  end
  orientations
end

def sea_monster_at?(image, top, left)
  SEA_MONSTER_OFFSETS.all? do |dy, dx|
    image[top + dy] && image[top + dy][left + dx] == '#'
  end
end

def count_sea_monsters(image)
  count = 0

  max_y = image.size - SEA_MONSTER_PATTERN.size
  max_x = image.first.size - SEA_MONSTER_PATTERN.first.size

  (0..max_y).each do |y|
    (0..max_x).each do |x|
      count += 1 if sea_monster_at?(image, y, x)
    end
  end

  count
end

def find_sea_monsters(image)
  all_image_orientations(image).each do |oriented|
    count = count_sea_monsters(oriented)
    return [count, oriented] if count > 0
  end

  [0, image]
end

def total_hashes(image)
  image.sum { |row| row.count('#') }
end

def sea_monster_hashes
  SEA_MONSTER_OFFSETS.size
end

image = build_full_image(arrs)

sea_monsters, monster_image = find_sea_monsters(image)
roughness = total_hashes(monster_image) - (sea_monsters * sea_monster_hashes)

puts "Water roughness: #{roughness}"


