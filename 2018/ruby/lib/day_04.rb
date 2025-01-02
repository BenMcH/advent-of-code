class Day04
  Entry = Struct.new(:date, :time, :action) do
    def hour
      time.split(":")[0].to_i
    end

    def minute
      time.split(":")[1].to_i
    end

    def guard_id
      gid = action[/#(\d+)/, 1]

      if gid
        gid.to_i
      else
        nil
      end
    end
  end

  def self.parse(str)
    str.split("\n").sort.map do |line|
      next if line.empty?
      date = line[/\d{4}-\d{2}-\d{2}/]
      time = line[/\d{2}:\d{2}/]
      action = line[/\].*/][1..].strip

      Entry.new(date, time, action)
    end
  end

  def self.part_1(input)
    input = parse(input)
    guards = {}

    guard_id = nil
    sleep_start = nil
    input.each do |entry|
      guard_id = entry.guard_id if entry.guard_id

      if entry.action == "falls asleep"
        sleep_start = entry.minute
      elsif entry.action == "wakes up"
        (sleep_start..entry.minute).each do |minute|
          guards[guard_id] ||= [0] * 60
          guards[guard_id][minute] += 1
        end
        sleep_start = nil
      end
    end

    sleepiest_guard = guards.max_by { |k, v| v.sum }
    sleepiest_minute = sleepiest_guard[1].index(sleepiest_guard[1].max)

    sleepiest_guard[0] * sleepiest_minute
  end

  def self.part_2(input)
    input = parse(input)
    guards = {}

    guard_id = nil
    sleep_start = nil
    input.each do |entry|
      guard_id = entry.guard_id if entry.guard_id

      if entry.action == "falls asleep"
        sleep_start = entry.minute
      elsif entry.action == "wakes up"
        (sleep_start..entry.minute).each do |minute|
          guards[guard_id] ||= [0] * 60
          guards[guard_id][minute] += 1
        end
        sleep_start = nil
      end
    end

    sleepiest_guard = guards.max_by { |k, v| v.max }

    sleepiest_minute = sleepiest_guard[1].index(sleepiest_guard[1].max)

    sleepiest_guard[0] * sleepiest_minute
  end
end
