test_input = File.read('./test-input.txt')
real_input = File.exists?('./input') ? File.read('./input') : ''

THEIR_PLAYS = ('A'..'C').to_a
MY_PLAYS = ('X'..'Z').to_a

def score_round(them, me)
	their_index = THEIR_PLAYS.index(them)
	my_index = MY_PLAYS.index(me)

	play_score = 1 + my_index

	return play_score + 3 if their_index == my_index # draw
	return play_score + 6 if (their_index + 1) % 3 == my_index # win
	return play_score + 0 # lose
end

def score_games(input, replacement_map = nil)
	input.lines.map {|line|
		them, me = *line.split

		me = replacement_map[[them, me]] if replacement_map

		score_round(them, me)
	}.sum
end

describe "Day 2" do
	it "Part 1" do
		scores = score_games(test_input)
		expect(scores).to eq(15)

		scores = score_games(real_input)
		puts "Part 1 #{scores}"
	end

	it "Part 2" do
		win = 'X'
		draw = 'Y'
		lose = 'Z'

		part_2_play_map = {}

		THEIR_PLAYS.product([win, draw, lose]).each do |group|
			part_2_play_map[group] = group[1] == win ? MY_PLAYS[THEIR_PLAYS.index(group[0]) - 1] :
															 group[1] == draw ? MY_PLAYS[THEIR_PLAYS.index(group[0])] :
  															MY_PLAYS[(THEIR_PLAYS.index(group[0]) + 1) % 3] 
		end

		expect(score_games(test_input, part_2_play_map)).to eq(12)

		puts "Part 2 #{score_games(real_input, part_2_play_map)}"
	end
end
