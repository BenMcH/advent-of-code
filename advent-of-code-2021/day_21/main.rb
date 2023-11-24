@dice = 0

def rollDeterministic
	@dice = 0 if @dice == 100
	@dice = @dice + 1

	@dice
end

def play_deterministic(p1_loc, p2_loc, prefix = "")
	player = 0
	rolls = 0
	locations = [p1_loc, p2_loc]
	scores = [0, 0]
	until scores.max >= 1000
		3.times do
			locations[player] = locations[player] + rollDeterministic

			locations[player] -= 10 until locations[player] <= 10
		end
		rolls += 3
		scores[player] += locations[player]
		player = (player + 1) % 2
	end

  "#{prefix}#{scores.min * rolls}"
end

puts play_deterministic(4, 8, 'Example: ')
puts play_deterministic(4, 7)

GameState = Struct.new(
	:p1_score,
	:p2_score,
	:p1_loc,
	:p2_loc,
	:player_turn
)

def play_round(game_state, dice_total)
	if game_state.player_turn == 0
		score, location, player = game_state.p1_score, game_state.p1_loc, 0
	else
		score, location, player = game_state.p2_score, game_state.p2_loc, 1
	end

	location += dice_total
	location -= 10 until location <= 10
	score = score + location

	if game_state.player_turn == 0
		GameState.new(score, game_state.p2_score, location, game_state.p2_loc, 1)
	else
		GameState.new(game_state.p1_score, score, game_state.p1_loc, location, 0)
	end
end

def play(game_state, cache = {})
	return cache[game_state] if cache[game_state]
	return [1, 0] if game_state.p1_score >= 21
	return [0, 1] if game_state.p2_score >= 21

	scores = [0, 0]

	range = (1..3).to_a
	range = range.product(range, range)

	range.each do |i, j, k|
			p1, p2 = play(play_round(game_state, i + j + k), cache)
			scores[0] += p1
			scores[1] += p2
	end

	cache[game_state] = scores

	scores
end

p1, p2 = play(GameState.new(0, 0, 4, 7, 0))

p [p1, p2].max
