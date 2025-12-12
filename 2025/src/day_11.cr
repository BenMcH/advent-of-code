class Day11
  def self.part_1(input : String) : Int32
    map = {} of String => Array(String)

    input.each_line do |line|
      key, rest = line.split(": ")
      map[key] = rest.split(" ")
    end

    paths = [] of Array(String)
    to_visit = [] of Array(String)
    to_visit << ["you"]

    while to_visit.size > 0
      path = to_visit.shift

      _paths = map[path[-1]]

      _paths.each do |p|
        if p == "out"
          paths << path
          next
        end

        unless path.includes?(p)
          to_visit << [*path, p]
        end
      end
    end
    paths.size
  end

  def self.count_paths(
    map : Hash(String, Array(String)),
    loc : String,
    has_fft = false,
    has_dac = false,
    cache = { {"out", false, false} => 0i64, {"out", true, true} => 1i64, {"out", false, true} => 0i64, {"out", true, false} => 0i64 },
  )
    key = {loc, has_fft, has_dac}
    return cache[key] if cache.has_key?(key)

    _paths = map[loc]

    ans = _paths.sum do |nloc|
      count_paths(map, nloc, has_fft || nloc == "fft", has_dac || nloc == "dac", cache)
    end

    cache[key] = ans
    ans
  end

  def self.part_2(input : String)
    map = {} of String => Array(String)

    input.each_line do |line|
      key, rest = line.split(": ")
      map[key] = rest.split(" ")
    end

    count_paths(map, "svr")
  end
end
