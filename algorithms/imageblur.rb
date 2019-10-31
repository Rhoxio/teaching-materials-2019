class Blur
  def initialize
    @ary = [
      [0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 1, 0, 0, 0],
      [0, 0, 0, 0, 1, 1, 0, 0],
      [0, 0, 0, 0, 1, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0]
    ]   
    @coordinates = [] 
  end

  def find_indexes
    @ary.each_with_index do |row, y|
      row.each_with_index do |value, x|
        if value == 1
          @coordinates.push([y, x])
        end
      end
    end
  end

  def display
    @ary.each do |set|
      p set
    end
  end

  def blur(iterations)
    iterations.times do 
      find_indexes
      @coordinates.each do |coord|
        y = coord[0]
        x = coord[1]

        @ary[y - 1][x] = 1 if y > 0 #top
        @ary[y + 1][x] = 1 if y < @ary.length - 1 #bottom
        @ary[y][x - 1] = 1 if x > 0 #left
        @ary[y][x + 1] = 1 if x < @ary[0].length - 1 #right
      end
    end
  end

end

# y = 3
# x = 1

# m[0][0]

b = Blur.new()
b.blur(3)
b.display