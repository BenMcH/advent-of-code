class Day07

  def self.part_1(input)
    deps = {}

    input.scan(/ [A-Z] /).each_slice(2) do |before, after|
      before.strip!
      after.strip!

      deps[before] ||= []
      deps[before].push(after)
    end

    eligible = deps.keys - deps.values.flatten

    str = ""
    while eligible.length > 0
      eligible.sort!
      ch = eligible.shift

      str = str + ch

      if deps.key?(ch)
        candidates = deps[ch]
        deps.delete(ch)

        candidates.each do |c|
          next if deps.values.flatten.include? c

          eligible << c
        end
      end
    end

    str
  end
  
  def self.part_2(input, workers = 5, offset = 60)
    deps = {}

    input.scan(/ [A-Z] /).each_slice(2) do |before, after|
      before.strip!
      after.strip!

      deps[before] ||= []
      deps[before].push(after)
    end

    eligible = deps.keys - deps.values.flatten

    workers = [nil] * workers

    total = 0

    while eligible.length > 0 || workers.any? {|w| !w.nil?}
      eligible.sort!
      worker_i = workers.find_index {|w| w == nil}

      unless worker_i.nil? || eligible.empty?
        ch = eligible.shift

        workers[worker_i] = [offset + ch.ord - 64, ch]
      else
        _workers = workers.filter { |w| w != nil }

        min = _workers.map { |w| w[0] }.min

        total += min if min >= 0

        p _workers
        _workers.each do |w|
          puts "#{w[0]} - #{min} = #{w[0] - min}"
          w[0] -= min
          ch = w[1]

          if w[0] == 0
            if deps.key?(ch)
              candidates = deps[ch]
              deps.delete(ch)

              candidates.each do |c|
                next if deps.values.flatten.include? c

                eligible << c
              end
            end
          end
        end

        workers = workers.map do |w|
          if !w.nil? && w[0] == 0
            nil
          else
            w
          end
        end
      end
    end

    total
  end
end
