def luhn(input)
  numbers = input.split("").reverse
  evens = numbers.values_at(* numbers.each_index.select {|i| i.even?}).map(&:to_i)
  odds = numbers.values_at(* numbers.each_index.select {|i| i.odd?}).map(&:to_i)

  odds = odds.map do |num|
    if (num * 2) > 9
      (num * 2).to_s.split.map(&:to_i).inject(:+)
    else
      (num * 2)
    end
  end

  final_values = odds + evens
  return final_values.inject(:+) % 10 === 0

end

# Stripe sample test, should return true
luhn(424242424242)