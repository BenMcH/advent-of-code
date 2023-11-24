fish_counter = File.read('input.txt').split(',').map(&:to_i).group_by(&:itself).map { |k, v| [k, v.count] }.to_h

def simulate_lantern_fish_day(fish_counter, days_to_simulate)
	new_fish_counter = {}

	fish_counter.keys.each do |fish|
		count = fish_counter[fish]

		if fish > 0
			new_fish_counter[fish - 1] = new_fish_counter[fish - 1].to_i + count
		elsif fish == 0
			new_fish_counter[6] = new_fish_counter[6].to_i + count
			new_fish_counter[8] = new_fish_counter[8].to_i + count
		end
	end

	return days_to_simulate == 1 ? new_fish_counter : simulate_lantern_fish_day(new_fish_counter, days_to_simulate - 1)
end

p simulate_lantern_fish_day(fish_counter, 80).values.sum
p simulate_lantern_fish_day(fish_counter, 250).values.sum
