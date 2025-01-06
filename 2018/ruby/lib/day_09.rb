
class Day09
  Node = Struct.new(:val, :left, :right) do

    def to_s(stop_at = self)
      if right == stop_at
        val.to_s
      else
        "#{val} #{right.to_s(stop_at)}"
      end
    end
  end

  def self.part_1(input)
    players, marbles = input.scan(/\d+/).map(&:to_i)

    game = Node.new(0)
    zero = game
    game.left = game
    game.right = game

    scores = [0] * players
    curr_index = 0
    curr_player = 0

    <<-INPUT
      However, if the marble that is about to be placed has a number which is a multiple of 23, something entirely different happens. First, the current player keeps the marble they would have placed, adding it to their score. In addition, the marble 7 marbles counter-clockwise from the current marble is removed from the circle and also added to the current player's score. The marble located immediately clockwise of the marble that was removed becomes the new current marble.
    INPUT

    (1..marbles).each do |marble|
      if marble % 23 == 0
        scores[curr_player] += marble        

        7.times do
          game = game.left
        end
        left = game.left
        right = game.right
        left.right = right
        right.left = left
        scores[curr_player] += game.val
        game = right
      else
        game = game.right
        new_node = Node.new(marble, game, game.right)

        game.right.left = new_node
        game.right = new_node

        game = game.right

      end

      curr_player = (curr_player + 1) % scores.length
    end
    
    scores.max
  end
  
  def self.part_2(input)
    players, marbles = input.scan(/\d+/).map(&:to_i)

    part_1("#{players} #{marbles * 100}")
  end
end
