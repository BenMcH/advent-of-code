class Day08
  alias JunctionBox = Tuple(Int64, Int64, Int64)

  def self.euclidean_distance(box1 : JunctionBox, box2 : JunctionBox) : Float64
    dx = box1[0] - box2[0]
    dy = box1[1] - box2[1]
    dz = box1[2] - box2[2]
    Math.sqrt((dx * dx + dy * dy + dz * dz).to_f64)
  end

  def self.parse(input : String)
    boxes = input.lines.map do |line|
      parts = line.split(",").map(&.to_i64)
      JunctionBox.new(parts[0], parts[1], parts[2])
    end

    circuits = boxes.map { |box| Set.new([box]) }

    distances = boxes.combinations(2).map do |(box1, box2)|
      {box1, box2, euclidean_distance(box1, box2)}
    end.sort_by(&.last)

    return circuits, distances
  end

  def self.make_connection(circuits : Array(Set(JunctionBox)), box1 : JunctionBox, box2 : JunctionBox)
    b1_circuit = circuits.find { |circuit| circuit.includes?(box1) }
    b2_circuit = circuits.find { |circuit| circuit.includes?(box2) }

    if b1_circuit != b2_circuit
      raise "nil" if b1_circuit.nil? || b2_circuit.nil?
      circuits << b1_circuit + b2_circuit
      circuits.delete(b1_circuit)
      circuits.delete(b2_circuit)
    end
  end

  def self.solve(input : String, num_connections : Int32)
    circuits, distances = parse(input)

    part_1 = 0i64

    while circuits.size > 1
      distance_info = distances.shift
      box1, box2 = distance_info

      make_connection(circuits, box1, box2)
      num_connections -= 1

      if num_connections == 0
        part_1 = circuits.map(&.size).sort.reverse[0..2].product.to_i64
      end

      if circuits.size == 1
        return part_1, box1[0] * box2[0]
      end
    end
  end
end
