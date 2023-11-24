slice = File.read('data.txt').split("\n").map{|row| row.split('')}

first_board = {}
second_board = {0 => {}}
first_board[0] = {}
second_board[0][0] = {}
slice.each.with_index do |row, y|
    first_board[0][y] = {}
    second_board[0][0][y] = {}
    row.each.with_index do |col, x|
        second_board[0][0][y][x] = col == '#'
        first_board[0][y][x] = col == '#'
    end
end

def list_neighbors(x, y, z)
    xs = (x-1..x+1).to_a
    ys = (y-1..y+1).to_a
    zs = (z-1..z+1).to_a

    xs.product(ys, zs) - [[x, y, z]]
end

def count_active_neighbors(x, y, z, board)
    count = 0
    list_neighbors(x, y, z).each do |loc|
        count += 1 if board[loc[2]] && board[loc[2]][loc[1]] && board[loc[2]][loc[1]][loc[0]]
    end

    count
end

6.times do
    new_board = {}

    z1, z2 = first_board.keys.minmax
    z1, z2 = z1 - 1, z2 + 1
    y1, y2 = first_board.values.flat_map{|row| row.keys.minmax }.minmax
    y1, y2 = y1 - 1, y2 + 1
    x1, x2 = first_board.values.flat_map{|row| row.values.flat_map {|col| col.keys.minmax} }.minmax
    x1, x2 = x1 - 1, x2 + 1
    (z1..z2).each do |z|
        new_board[z] = {}
        (y1..y2).each do |y|
            new_board[z][y] = {}
            (x1..x2).each do |x|
                neighbors = count_active_neighbors(x, y, z, first_board)

                new_board[z][y][x] = first_board[z] && first_board[z][y] && first_board[z][y][x] ? (2..3).include?(neighbors) : neighbors == 3
            end
        end
    end
    first_board = new_board
end


count = 0
first_board.values.each do |z|
    z.values.each do |row|
        row.values.each do |cell|
            count += 1 if cell
        end
    end
end

p count

def list_neighbors_4d(x, y, z, w)
    xs = (x-1..x+1).to_a
    ys = (y-1..y+1).to_a
    zs = (z-1..z+1).to_a
    ws = (w-1..w+1).to_a

    xs.product(ys, zs, ws) - [[x, y, z, w]]
end

def count_active_neighbors_4d(x, y, z, w, board)
    count = 0
    list_neighbors_4d(x, y, z, w).each do |loc|
        count += 1 if board[loc[3]] && board[loc[3]][loc[2]] && board[loc[3]][loc[2]][loc[1]] && board[loc[3]][loc[2]][loc[1]][loc[0]]
    end

    count
end

6.times do
    new_board = {}

    w1, w2 = second_board.keys.minmax
    w1, w2 = w1 - 1, w2 + 1
    z1, z2 = second_board.values.flat_map{|zs| zs.keys.minmax}.minmax
    z1, z2 = z1 - 1, z2 + 1
    y1, y2 = second_board.values.flat_map{|zs| zs.values.flat_map {|ys| ys.keys.minmax} }.minmax
    y1, y2 = y1 - 1, y2 + 1
    x1, x2 = second_board.values.flat_map{|zs| zs.values.flat_map {|ys| ys.values.flat_map{|xs| xs.keys.minmax}} }.minmax
    x1, x2 = x1 - 1, x2 + 1
    (w1..w2).each do |w|
        new_board[w] = {}
        (z1..z2).each do |z|
            new_board[w][z] = {}
            (y1..y2).each do |y|
                new_board[w][z][y] = {}
                (x1..x2).each do |x|
                    neighbors = count_active_neighbors_4d(x, y, z, w, second_board)

                    new_board[w][z][y][x] = second_board[w] && second_board[w][z] && second_board[w][z][y] && second_board[w][z][y][x] ? (2..3).include?(neighbors) : neighbors == 3
                end
            end
        end
    end
    second_board = new_board
end


count = 0
second_board.values.each do |w|
    w.values.each do |z|
        z.values.each do |row|
            row.values.each do |cell|
                count += 1 if cell
            end
        end
    end
end

p count

