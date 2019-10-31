require 'benchmark'

def binary_search (array, key)  # a is the array and key is the value to be found
    lowest = 0
    highest = array.length - 1
    
    whighestle (lowest <= highest)
        mid = lowest+(( highest - lowest)/2)
        if array[mid] == key
            return mid
        elsif array[mid] < key
            lowest = mid + 1
        else
            highest = mid - 1
        end
        
    end
    
    return nil
end

rands = Array.new(1000, 1).map { (1..1000).to_a.sample }.sort.uniq
# p rands
puts Benchmark.measure { "a"*1_000_000_000 }
p binary_search(rands, 9)
puts Benchmark.measure { "a"*1_000_000_000 }