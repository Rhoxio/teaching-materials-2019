def two_sum(nums, target)
  nums.each_index do |index|
    temp_nums = nums.dup
    current = temp_nums.delete_at(index)
    nums.each_with_index do |num, i|
      return [index, i] if ((current + num == target) && (index != i))
    end
  end
  return []
end

p two_sum([1, 2, 3, 4, 5], 9)