class Animal
  attr_reader :species, :name, :diet, :energy, :muscle, :fat

  # attr_reader is setting up 'getter' methods for all of the attributes present on initialization.

  # This allows you to call Animal.name, Animal.species, Animal.diet, etc to retrieve information about the
  # animal, but does NOT set up 'setter' methods that would allow you to set attributes by doing something like
  # Animal.name = "Carl". We do this because once the animal is created, we simply need to be able to retrieve information as
  # this is cleaner OO, and amendments should be passed in as a chunk of data to be processed if this were a specifically clean implementation of OO.

  def initialize(species, name, diet)
    if ![:omnivore, :herbivore, :carnivore].any?(diet)
      raise ArgumentError, "Please provide a valid diet type for your Animal: i.e. :omnivore, :herbivore, :carnivore" 
    end

    @species = species
    @name = name

    @diet = diet
    @hunger = 0
    
    @energy = 10
    @muscle = 10
    @fat = 10
  end

  def stats
    return {
      energy: @energy,
      muscle: @muscle,
      fat: @fat
    }
  end

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

  def process_nutrition!(nutrition)
    # The values here are arbitrary and not meant to be balanced - it's just an example! :) I'm not a nutritionist, and these aren't real ratios.
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

# The food class is fairly similar, but is designed to be consumed by another class or potentially amended by
# things such as GMO engineering, age, or other environmental factors. This was a specific design decision, as 
# I figured it was more reasonable to be able to change the property of a food than an animal for what I was trying to 
# accomplish.

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

  # Just a simple utility method like Animal.stats. This is actually what the animal is asking for
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
    # Could += certain nutrients in here. Try implementing it!
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