require 'aoc/helpers'

test_input = File.read('./test-input.txt')
real_input = get_input(2022, 19, File.read('/home/vscode/.adventofcode.session'))

part_1_expected = 33
part_2_expected = 2

Blueprint = Struct.new(
	:id,
	:ore_robot_cost,
	:clay_robot_cost,
	:obsidian_robot_cost_ore,
	:obsidian_robot_cost_clay,
	:geode_robot_cost_ore,
	:geode_robot_cost_obsidian
)

State = Struct.new(
	:blueprint,
	:minutes_left,
	:ore_robots,
	:clay_robots,
	:obsidian_robots,
	:geode_robots,
	:ore,
	:clay,
	:obsidian,
	:geodes,
	:max_ore,
	:max_clay,
	:max_obsidian
) do
	def initialize(*)
		super
		self.ore_robots ||= 1
		self.clay_robots ||= 0
		self.obsidian_robots ||= 0
		self.geode_robots ||= 0
		self.ore ||= 0
		self.clay ||= 0
		self.obsidian ||= 0
		self.geodes ||= 0
		self.max_ore = [self.blueprint.geode_robot_cost_ore, self.blueprint.ore_robot_cost, self.blueprint.clay_robot_cost].max
		self.max_clay = self.blueprint.obsidian_robot_cost_clay
		self.max_obsidian = self.blueprint.geode_robot_cost_obsidian
	end

	def next_states
		return [self] if self.minutes_left == 0

		states = []
		dup_state = self.dup
		ore_costs = [
			self.blueprint.geode_robot_cost_ore,
			self.blueprint.obsidian_robot_cost_ore,
			self.blueprint.clay_robot_cost,
			self.blueprint.ore_robot_cost
		]
		needs_more_obsidian = (
			self.max_obsidian > self.obsidian_robots.to_f &&
			self.ore >= self.blueprint.obsidian_robot_cost_ore &&
			self.clay >= self.blueprint.obsidian_robot_cost_clay
		)
		ore_cost = self.blueprint.ore_robot_cost
		clay_cost = self.blueprint.clay_robot_cost
		needs_more_clay = self.max_clay > self.clay_robots && self.ore.between?(clay_cost, clay_cost + self.clay_robots) && self.minutes_left > 1
		needs_more_ore =  self.max_ore > self.ore_robots && self.minutes_left > 1 && self.ore.between?(ore_cost, ore_cost + self.ore_robots)

		dup_state.minutes_left -= 1

		needs_more_geodes = self.ore >= self.blueprint.geode_robot_cost_ore && self.obsidian >= self.blueprint.geode_robot_cost_obsidian

		if needs_more_geodes
			state = self.dup

				state.geode_robots += 1
				state.ore -= self.blueprint.geode_robot_cost_ore
				state.obsidian -= self.blueprint.geode_robot_cost_obsidian

				states << state
		elsif needs_more_obsidian
				state = dup_state.dup

				state.obsidian_robots += 1
				state.ore -= self.blueprint.obsidian_robot_cost_ore
				state.clay -= self.blueprint.obsidian_robot_cost_clay

				states << state
		else
			
			if needs_more_clay && self.ore >= self.blueprint.clay_robot_cost
				state = dup_state.dup

				state.clay_robots += 1
				state.ore -= self.blueprint.clay_robot_cost

				states << state
			end

			if self.ore >= self.blueprint.ore_robot_cost && needs_more_ore
				state = dup_state.dup

				state.ore_robots += 1
				state.ore -= self.blueprint.ore_robot_cost

				states << state
			end
		end

		if (self.ore < self.max_ore || self.clay < self.max_clay || self.obsidian < self.max_obsidian) && !needs_more_geodes
			states << dup_state
		end

		states.each do |state|
			state.ore += self.ore_robots
			state.clay += self.clay_robots
			state.obsidian += self.obsidian_robots
			state.geodes += self.geode_robots
		end

		states
	end
end

def parse_input(input)
	lines(input).map{|l| Blueprint.new(*get_numbers(l))}
end

def solution_part_1(input)
	blueprints = parse_input(input)
	states = blueprints.map{|bp| State.new(bp, 24)}

	max = 0
	total_quality = 0
	states.each.with_index do |state, i|
		round = 0
		inner_states = [state]

		until round == 24
			inner_states = inner_states.flat_map(&:next_states)
			local_max = inner_states.map(&:geodes).max

			inner_states = inner_states.filter{|g| g.geodes >= local_max - 5}
			round += 1
		end

		new_quality = inner_states.map{|a| a.blueprint.id * a.geodes}.max

		total_quality += new_quality
	end

	total_quality
end

def solution_part_2(input)
	blueprints = parse_input(input)[0..2]
	states = blueprints.map{|bp| State.new(bp, 32)}

	qualities = []
	states.each.with_index do |state, i|
		round = 0
		inner_states = [state]

		until round == 32
			inner_states = inner_states.flat_map(&:next_states)
			local_max = inner_states.map(&:geodes).max

			inner_states = inner_states.filter{_1.geodes >= local_max - 5}
			round += 1
		end


		qualities << inner_states.map(&:geodes).max
	end

	qualities.reduce(:*)
end

describe "Day 19" do
	
	it "Part 1 should pass" do
		expect(solution_part_1(test_input)).to eq(part_1_expected)
		p solution_part_1(real_input)
	end

	it "Part 2 should pass" do
		p solution_part_2(real_input)
	end
end
