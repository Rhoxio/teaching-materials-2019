require 'awesome_print'
require 'pry'
require 'rb-readline'

# ----------------------------------------------------------------------------------------------------------------
# THIS WHOLE FILE IS THE STUFF I WORKED ON WITH STUDENTS AS WE TESTED STUFF OUT.                                 
# SOME OF IT IS NOT RUNNING - OR HALF RUNNING. COPY-PASTE AT YOUR OWN RISK.
# ----------------------------------------------------------------------------------------------------------------



# =begin

# This is a simple example of some Object Oriented Programming focusing on a dynamic Animal class that includes some basic
# functionality to model animals being able to eat certain foods and gain stats from said food. This is only an abstraction
# to a base level of interaction and isn't wholly representative of the actual reality of feeding animals a diverse diet, but 
# the overarching concepts of OO pop out in a few ways:
  
#   1. Each class has methods that maintain single responsibility. Essentially, they execute a single action or a related set of actions that make sense
#      for the level of logical abstraction you are going for.

#   2. Each method on the class is doing one of a few things: ASKING the other class to do something with given data OR amending itself OR
#      providing specific, structured data to work against without 'demanding' it from the other class by calling specific attributes
#      on the class. Grouping is important!

#   3. Maintains its own state and does not have values set outside of the class itself. If there are changes made, the other class is ASKING THE BASE CLASS
#      TO MAKE THE CHANGES, BUT NOT DIRECTLY FORCING IT TO DO SO IN THE SUPERCLASSES LOGIC AS THE CONSTRAINTS ARE SPECIFIC TO THE CLASS AND NOT TO THE IMPLEMENTATION
#      AS A WHOLE, more or less. 

# You don't want the 'Animal' class to forefully set any attributes on the 'Food' class ANYHWERE AT ALL. You want to pass data and ask the
# Food to change itself if anything, but literally hard-setting attributes from the Animal class is a bad idea.

# The main idea surrounding OO programming is that you want to have your classes interact with one another and send messages, but you should
# NOT have any class directly amending another class's attributes without ASKING it to do so through a method on the class to be amended, as this
# standardizes the ways in which the data can go in and out of your class.

# =end

# # We will start with the Animal class initially. The animal has some attributes and data associated with it - namely the 
# # instance variables (@whatever) in the initialize method. This is how we persist data in runtime (when your code is running)
# # without having a database to reference against. 

# # The data will not 'save' in the conventional sense, but persists in runtime space until the Ruby code is done executing.

class Animal
  attr_reader :species, :name, :diet, :energy, :muscle, :fat

  # attr_reader is setting up 'getter' methods for all of the attributes present on initialization.

  # This allows you to call Animal.name, Animal.species, Animal.diet, etc to retrieve information about the
  # animal, but does NOT set up 'setter' methods that would allow you to set attributes by doing something like
  # Animal.name = "Carl". We do this because once the animal is created, we simply need to be able to retrieve information as
  # this is cleaner OO, and amendments should be passed in as a chunk of data to be processed if this were a specifically clean implementation of OO.

  def initialize(species, name, diet)
    # This thing throws an error if the Animal class is provided with a value for 'diet' that doesn't meet the level
    # of logical abstraction we have established to reach our goal of having an animal that has dietary contraints.
    if ![:omnivore, :herbivore, :carnivore].any?(diet)
      raise ArgumentError, "Please provide a valid diet type for your Animal: i.e. :omnivore, :herbivore, :carnivore" 
    end

    # Setting up internal data representation and instance-based variable persistence...
    @species = species
    @name = name

    @diet = diet
    @hunger = 0
    
    @energy = 10
    @muscle = 10
    @fat = 10
  end

  # This is a simple utility method to grab the relevant athletic stats to be returned from methods that amend these attriutes directly
  # and need to be grouped as returned as such for things like control flow, validation, and whatever else we might need the info for
  # so we don't have to keep constructing it in other methods. (See #eat and #process_nutirition for examples of using it). 
  def stats
    return {
      energy: @energy,
      muscle: @muscle,
      fat: @fat
    }
  end

  # How the animal eats. Notice that I am checking here wether or not the animal can eat the
  # food at all before even attempting to process the nutrition, as there's no reason to run code or make checks against anything if 
  # the initial input is invalid to begin with.

  # I also made the animal lose energy out of 'annoyance' if they can't eat the food as this is how I wanted to model the reality that these animals exist in.
  def eat(food)

    if can_eat.include?(food.type)
      p "#{@name} ate the #{food.name}!"
      process_nutrition!(food.nutrition)
      return stats
    else
      p "#{@name} turns away from the #{food.name}!"
      @energy -= 1
      return stats
    end
  end

  # This is encapsulted here as it may be that we want to add nutrition from other items like vitamins, supplements, shots, IV fluid etc. at a later date.
  # This is quite literally how the animal's metabolic system is simulated to work, and the values I am dividing by could just as easily
  # we replaced by metabolite values instead of static intergers. I am keeping it encapsulated because it is, in fact, a different set of logic and
  # actions than simply having the ability to 'eat' a certain food, which could have its own levels of abstraction and ways of doing things
  # independent of how the animal processes the nutrition from the food itself.
  def process_nutrition!(nutrition)
    @energy += ((nutrition[:carbs] / 5) + (nutrition[:sugar] / 3) + (nutrition[:fat] / 12) + (nutrition[:protien] / 2)) / 2
    @hunger -= nutrition.map {|k,v| v }.inject(:+)
    @muscle += nutrition[:protien] / 5
    @fat += nutrition[:fat] / 3
    return stats
  end

  # This is simply set up as a reference to ensure that if an animal has a certain diet, they can eat certain foods.
  # I check against this with .include? (see #eat) as it's meant to represent a set of valid data for the Animal to work against.
  def can_eat
    if @diet == :carnivore
      return [:meat]
    elsif @diet == :herbivore
      return [:vegetable, :fruit, :starch, :seed]
    elsif @diet == :omnivore
      return [:vegetable, :fruit, :starch, :seed, :meat]
    end
  end

end

# # The food class is fairly similar, but is designed to be consumed by another class or potentially amended by
# # things such as GMO engineering, age, or other environmental factors. This was a specific design decision, as 
# # I figured it was more reasonable to be able to change the property of a food than an animal for what I was trying to 
# # accomplish.

class Food
  # Getter method setup.
  attr_reader :name

  # Getter & Setter method setup. 
  attr_accessor :sugar, :fat, :protien, :carbs, :type

  # I am passing in a default hash here to ensure that, at the very least, food will have a 0 
  # value for all of its attributes. This eliminates the potential for nil errors and will make it so that 
  # non-muliplication math logic will maintain identity.
  def initialize(name, type, nutrition = {sugar: 0, fat: 0, protien: 0, carbs: 0})
    @sugar = nutrition[:sugar]
    @fat = nutrition[:fat] 
    @protien = nutrition[:protien]
    @carbs = nutrition[:carbs]

    @name = name
    @type = type # i.e. :meat, :vegetable, :fruit, :starch, :seed
  end

  # Just a simple utility method like Animal.stats. This is atually what the animal is asking for
  # when it needs to process the nutrition gained from the food. We keep it here as there may be other modifiers not specific to the
  # animal that the food needs to amend on itself. Eventually, more transformations in the data may happen here,
  # so its a best to keep this encapsulated as we don't know what we are going to need to make that mechanic work later in development. 
  def nutrition
    return {
      sugar: @sugar,
      fat: @fat,
      protien: @protien,
      carbs: @carbs
    }
  end

  def supplement(attr, value)

  end

end

# We are just making a bat and feeding it some fruit here. Run the code and see how it works!

bat = Animal.new('fruit_bat', "Batty the Fruit Bat", :herbivore)
apple = Food.new('apple', :fruit, {
  sugar: 80,
  fat: 10,
  protien: 5,
  carbs: 40
})
guava = Food.new('guava', :fruit, {
  sugar: 50,
  fat: 20,
  protien: 30,
  carbs: 10
})
p bat.eat(apple)
p bat.eat(guava)


# # # hash = {
# # #   a: 1, 
# # #   b: 2,
# # #   c: 3
# # # }

# # # hash[:a]  # => 1
# # # hash[:b]  # => 2

# # # def deal_deck(players = ['barry', 'josephine', 'jeremy', 'joe', 'karen'])
# # #   hands = {}
# # #   players.each do |player|
# # #     if !hands.key?(player)
# # #       hands[player] = [deck.deal]      
# # #     elsif hands.key?(player)
# # #       hands[player] << deck.deal
# # #     end
# # #   end
# # #   return hands
# # # end

# # # {
# # #   barry: [],
# # #   josesphine: []
# # # }


# # # puts "h"
# # # sleep(0.3)
# # # puts "\e[H\e[2J".chomp
# # # puts "e"
# # # sleep(0.3)
# # # puts "\e[H\e[2J".chomp
# # # puts "l"
# # # sleep(0.3)
# # # puts "\e[H\e[2J".chomp
# # # puts "l"
# # # sleep(0.3)
# # # puts "\e[H\e[2J".chomp
# # # puts "o"
# # # sleep(0.3)
# # # puts "\e[H\e[2J".chomp
# # # puts "!"

# # # new_array = ['aa', 'anan', 'but', 'before' ,'after'].detect { |word| word.include?("b") } 
# # # p new_array

# # # p (5..10).inject(:-)

# # # p 4.+(5)


# # # def map(collection)
# # #   collection.each do |item|
# # #     yield(item)
# # #   end
# # # end

# # # numbers = [1,2,3]

# # # map(numbers) { |number| p number }

# # # 4.+(5) {|num| num }


# # # ary = [
# # #   [1,2,3,4,5],
# # #   [1,7,1,9,10],
# # #   [6,8,9,1,1]
# # # ]

# # # results = []

# # # ary.each_with_index do |row, y_index|
# # #   row.each_with_index do |value, x_index|
# # #     if value == 1
# # #       results.push([y_index, x_index])
# # #     end
# # #   end
# # # end

# # # # p results

# # # results.each do |coordinate|
# # #   y = coordinate[0]
# # #   x = coordinate[1]
# # #   ary[y][x] = "one"
# # # end

# # # p ary

# # # other_animals = [
# # #   [:dog, "Troy"],

# # # ]

# # # species = other_animals[0][0]
# # # name = other_animals[0][1]

# # # animals = {
# # #   dog: "Troy",
# # #   cat: "Angel",
# # #   horse: "Rudy"
# # # }

# # # animals[:dog]



# # # names = ["John", "Jodie", "Rick"]
# # # ages = [12, 90, 78]

# # # hash = {}

# # # names.each do |name|
# # #   if !hash.key?(name)
# # #     hash[name] = ages[0]
# # #   end
# # # end

# # # # p hash

# # # names.each do |name|
# # #   if !hash.key?(name)
# # #     hash[name] = ages[0]
# # #   elsif hash.key?(name)
# # #     hash[name] = ages[1]
# # #   end
# # # end

# # # # p hash

# # # var = false ? 2 : 3

# # # p var

# # # # class Thing
# # # #   def self.print(string)
# # # #     p string
# # # #   end
# # # # end

# # # # Thing.print("Dog")

# # # p (5..10).inject(:+)

# # # names = ["John", "Jodie", "Rick"].map { |name| name + " Smith" }.join(" & ").split("jl")

# # # p names

# # # ary = [
# # #   [ 1,2,3,4,5, [5,4,3,2,1] ], [6,7,8,9,10]
# # # ]

# # # p ary[1][5]

# class Blur
#   def initialize
#     @ary = [
#       [0, 0, 0, 0, 0, 0, 0, 0],
#       [0, 0, 0, 0, 1, 0, 0, 0],
#       [0, 0, 0, 0, 1, 1, 0, 0],
#       [0, 0, 0, 0, 1, 0, 0, 0],
#       [0, 0, 0, 0, 0, 0, 0, 0],
#       [0, 0, 0, 0, 0, 0, 0, 0],
#       [0, 0, 0, 0, 0, 0, 0, 0],
#       [0, 0, 0, 0, 0, 0, 0, 0]
#     ]   
#     @coordinates = [] 
#   end

#   def find_indexes
#     @ary.each_with_index do |row, y|
#       row.each_with_index do |value, x|
#         if value == 1
#           @coordinates.push([y, x])
#         end
#       end
#     end
#   end

#   def display
#     @ary.each do |set|
#       p set
#     end
#   end

#   def blur(iterations)
#     iterations.times do 
#       find_indexes
#       @coordinates.each do |coord|
#         y = coord[0]
#         x = coord[1]

#         @ary[y - 1][x] = 1 if y > 0 #top
#         @ary[y + 1][x] = 1 if y < @ary.length - 1 #bottom
#         @ary[y][x - 1] = 1 if x > 0 #left
#         @ary[y][x + 1] = 1 if x < @ary[0].length - 1 #right
#       end
#     end
#   end

# end

# # y = 3
# # x = 1

# # m[0][0]

# b = Blur.new()
# b.blur(3)
# b.display






# # # [0, 0, 0, 0, 0, 0, 0, 0]
# # # 0
# # # "-----"
# # # [0, 0, 0, 0, 0, 0, 0, 0]
# # # 1
# # # "-----"
# # # [0, 0, 0, 0, 0, 0, 0, 0]
# # # 2
# # # "-----"
# # # [0, 0, 0, 1, 0, 0, 0, 0]
# # # 3
# # # "-----"
# # # [0, 0, 0, 0, 0, 0, 0, 0]
# # # 4
# # # "-----"
# # # [0, 0, 0, 0, 0, 0, 0, 0]
# # # 5
# # # "-----"
# # # [0, 0, 0, 0, 0, 0, 0, 0]
# # # 6
# # # "-----"
# # # [0, 0, 0, 0, 0, 0, 0, 0]
# # # 7
# # # "-----"


# # array = (1..5).to_a

# # p array.inject(:+)

# # p 4.+(5)

# # array.inject(0) do |sum, num|
# #   p "Sum: "+sum.to_s
# #   p "Num: "+num.to_s
# #   p "--------"

# #   sum.send("+")(num)
# # end

# # "Sum: 0"
# # "Num: 1"
# # "--------"
# # "Sum: 1"
# # "Num: 2"
# # "--------"
# # "Sum: 3"
# # "Num: 3"
# # "--------"
# # "Sum: 6"
# # "Num: 4"
# # "--------"
# # "Sum: 10"
# # "Num: 5"
# # "--------"

# # PROBLEM: Square and add up all numbers in a given array. 

# # method([1,2,3,4])

#   # I will need to iterate ofer the array and be able to square the given value
#     # array.each do num
#       # num ** 2 
#         # -> to another array that holds values

#   # After the values have been exponentiated...
#     # Add them all together
#       # array.inject or something?



# # class Dog
# #   attr_reader :name
# #   def intialize(name)
# #     @name = name ||= "Roy" 
# #   end


# # end

# # Dog.new # Roy
# # Dog.new("Mickey") #Mickey


# array = [1,2,3,4,5]

# def map(collection)
#   counter = 0
#   tmp = "dog"
#   p tmp
#   while counter != collection.length
#     tmp = yield tmp
#     counter += 1
#   end
#   p tmp
# end

# map(array) { |n| n+"!" }


# # each(array) do |num|
# #   p "this is working: #{num}"
# # end


# # array.inject(0) {|total,num| total + num }
# bool = nil
# result = bool ? 'this will be returned if true' : 'this will be returned if false'
# # p result

# # if nil
# #   p "thing is here"
# # end

# # +=
# # -=
# # *=
# # /=

# # ||=

# name = nil
# full_name = name ||= "Blank"
# p full_name

# def two_sum(nums, target)
#   nums.each_index do |index|
#     temp_nums = nums.dup
#     current = temp_nums.delete_at(index)
#     nums.each_with_index do |num, i|
#       return [index, i] if ((current + num == target) && (index != i))
#     end
#   end
#   return []
# end

# p two_sum([1, 2, 3, 4, 5], 9)

# def reverse(x)

#     negative = x < 0 
#     chunk = x.to_s.reverse.to_i
#     chunk_length = x.to_s.length
#     chunk *= -1 if negative
#     return 0 if (chunk < -2147483648 || chunk > 2147483648)
#     return chunk
# end

# p reverse(-2147483412)

# "0" => true
# " 0.1 " => true
# "2e10" => true
# " -90e3   " => true
# " 6e-1" => true
# "53.5e93" => true

# "abc" => false
# "1 a" => false
# " 1e" => false
# "e3" => false
# " 99e2.5 " => false
# " --6 " => false
# "-+3" => false
# "95a54e53" => false

# def is_number(string)
#   # string = string.gsub(" ", "")

#   decimal_format = /\d+[.]\d+/
#   invalid_decimal = (string =~ /\A.[ ]\d/)
#   more_than_one_operator = (string =~ /([+]{2,}|[-+.]{2,})/)

#   simple_numeric = string =~ /[-+]?([0-9]*\.[0-9]+|[0-9]+)/
#   exponentiated = string.include?("e")
  
#   return false if more_than_one_operator

#   if simple_numeric && !exponentiated
#     return false if invalid_decimal
#     p 'ran simple_numeric'
#     return true
#   end

#   if exponentiated
#     p 'ran exponentiated'
#     chunks = string.split("e")
#     return false if chunks.length <= 1
#     c_1, c_2 = chunks[0], chunks[1]
#     return true if (c_1 =~ decimal_format) && !(c_2 =~ decimal_format)
#     return true if (c_1 =~ /\d+/) && (c_2 =~ /\d+/)
#   end

#   return false
# end

# p is_number(". 1")

# def longest_dup_substring(s)
#   characters = s.split("")
  
#   characters.each_with_index do |character, index|
#     # Keeping track of the indexes here in the loop instead.
#     potential_match_starts = []
#     characters.each_with_index do |c, i|

#       sequential_matches = 0
#       # p [character, index]
#       # p [c, i]
#       # p "--"
#       if c == character && i < index
#         potential_match_starts.push(i)
#       end

#       p potential_match_starts

#       potential_match_starts.each do |p_index|
#         # p p_index
#         next_character = characters[index+1]
#         next_potential_character = characters[p_index+1]

#         p "next: #{next_character}"
#         p "next potential #{next_potential_character}"
#         p "---"

#         # if next_character == next_potential_character
#         #   sequential_matches += 1
#         # end 
#       end
      
#       p sequential_matches

#     end
#   end
# end

# longest_dup_substring('banana')

# def max_sub_array(nums)
#   max = nums[0]
#   nums.each_index do |start_index|
#       nums.each_index do |top_end|
#           range = nums[start_index..top_end]
#           total = range.inject(:+)
#           if range && total
#               if total > max
#                   max = total
#               end                  
#           end
#       end  
#   end
#   return max
# end

# class Dog

#   def data
#     {
#       name: "Ben"
#     }
#   end

#   def self.bark
#     p data[:name]
#   end
# end

# Dog.


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


p luhn("424242424242")

# def self_dividing_numbers(left, right)
#     range = (left..right).to_a.select{|n| n%10 != 0}
#     results = []
#     range.each do |num|
#       numerals = num.to_s.split("").map(&:to_i).select{|n| !n.to_s.include?("0") }
#       self_dividing = []

#       numerals.each do |numeral|
#         if num % numeral == 0
#           self_dividing.push(numeral)
#         end
#       end

#       if self_dividing.length == numerals.length
#         results.push(num)
#       end

#     end
#     return results
# end

# p self_dividing_numbers(1, 708)


# a = [[1,2,3,4,5], [6,7,8,9,10]]
# a[1][1] = 90329
# p a



# def prying_into_the_method
#     inside_the_method = "We're inside the method"
#     puts inside_the_method
#     puts "We're about to stop because of pry!"
#     binding.pry
#     this_variable_hasnt_been_interpreted_yet = "The program froze before it could read me!" 
#     puts this_variable_hasnt_been_interpreted_yet
# end

# prying_into_the_method

# def array_pair_sum(nums)
#   groups = nums.sort.each_slice(2).to_a
#   total = 0
#   groups.each do |group|
#     total += group.min
#   end
#   return total
# end

# nums = [1,4,3,2]

# p array_pair_sum(nums)

# m = 
# [
#   [1, 2, 3, 4, 5], 
#   [6, 7, 8, 9, 10]
# ]

# m[1][1]


# array = [1,2,3,4,5]

# def each(arg)
#   arg.each do |a|
#     yield a
#   end
# end

# each(array) {}





