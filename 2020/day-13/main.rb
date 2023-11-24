time, ids = File.read('./data.txt').split

time = time.to_i
ids = ids.split(',').map(&:to_i)
bus_ids = ids.select{|id|id > 0}
times = bus_ids.map{|id| (time..time+id).find{|actual_time| actual_time % id == 0 }}

bus_index = times.rindex(times.min)
p (times[bus_index] - time) * bus_ids[bus_index]

bus_indexes = bus_ids.map{|id| ids.index(id)}

time = bus_ids[0]
step = bus_ids[0]
current_index = 1

while step < bus_ids.reduce(&:*)
  time += step

  if (time + bus_indexes[current_index]) % bus_ids[current_index] == 0
    step *= bus_ids[current_index]
    current_index += 1
  end
end

p time
