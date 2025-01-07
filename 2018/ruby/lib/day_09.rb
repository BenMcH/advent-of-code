
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
    game.left = game
    game.right = game

    scores = [0] * players

    (1..marbles).each do |marble|
      if marble % 23 == 0
        curr_player = marble % scores.length

        7.times do
          game = game.left
        end
        right = game.right
        left = game.left
        left.right = right
        right.left = left
        scores[curr_player] += marble + game.val
        game = right
      else
        game = game.right
        new_node = Node.new(marble, game, game.right)

        game.right.left = new_node
        game.right = new_node

        game = new_node
      end
    end
    scores.max
  end
  
  def self.part_2(input)
    players, marbles = input.scan(/\d+/).map(&:to_i)

    part_1("#{players} #{marbles * 100}")
  end
end
