def self_dividing_numbers(left, right)
    range = (left..right).to_a.select{|n| n%10 != 0}
    results = []
    range.each do |num|
      numerals = num.to_s.split("").map(&:to_i).select{|n| !n.to_s.include?("0") }
      self_dividing = []

      numerals.each do |numeral|
        if num % numeral == 0
          self_dividing.push(numeral)
        end
      end

      if self_dividing.length == numerals.length
        results.push(num)
      end

    end
    return results
end

p self_dividing_numbers(1, 708)