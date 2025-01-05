class Day08
  Node = Struct.new(:children, :metadata, :val) do

    def all_metadata
      metadata + children.flat_map(&:all_metadata)
    end

    def value
      return metadata.sum if children.empty?

      metadata.sum do |i|
        obj = children[i - 1]

        if obj != nil
          obj.value
        else
          0
        end
      end
    end
  end

  def self.parse(nums)
    children_count, metadata_count, *nums = nums
    children = []

    while children.length < children_count
      new_child, nums = parse(nums)

      children << new_child
    end

    metadata = nums.take(metadata_count)
    nums = nums.drop(metadata_count)

    return Node.new(children, metadata), nums
  end

  def self.part_1(input)
    nums = input.scan(/\d+/).map(&:to_i)

    a, _ = parse(nums)

    a.all_metadata.sum
  end
  
  def self.part_2(input)
    nums = input.scan(/\d+/).map(&:to_i)

    a, _ = parse(nums)

    a.value
  end
end
