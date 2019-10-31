def array_pair_sum(nums)
  groups = nums.sort.each_slice(2).to_a
  total = 0
  groups.each do |group|
    total += group.min
  end
  return total
end

nums = [1,4,3,2]

p array_pair_sum(nums)