class Node
  attr_accessor :data, :pointer

  def initialize(data, pointer = nil)
    @data = data
    @pointer = pointer
  end

  def next?
    !@pointer.nil?
  end
end

class LinkedList
  attr_accessor :head

  def initialize(data)
    @head = Node.new(data)
  end

  def push(data)
    @head = Node.new(data, @head)
  end

  def append(data)
    current_node = @head
    while current_node.next?
      # Cycling...
      current_node = current_node.pointer
    end

    new_node = Node.new(data, nil)
    current_node.pointer = new_node
  end

  def each
    return nil unless block_given?
    current_node = @head
    while current_node.next?
      yield current_node
      current_node = current_node.pointer
    end
  end

  def remove(node)
    return nil unless node

    if node == @head
      if !@head.next?
        @head = @head.pointer = nil
      else
        @head = @head.pointer
      end
    else
      tmp = @head
      while tmp && tmp.pointer != node
        tmp = tmp.pointer
      end
      tmp.pointer = node.pointer if tmp
    end
  end

  #  @head[3, p1] -> p1[5, p2] -> p2[7, p3] -> p3[9, nil] ....

  def reverse
    current_node = @head
    previous_node = nil
    next_node = nil # p1  

    while current_node.next?
      # Setting...
      next_node = current_node.pointer
      current_node.pointer = previous_node

      # Cycling...
      previous_node = current_node
      current_node = next_node
    end
    # Set new head to previous node as we have reversed the flow of data.
    @head = previous_node
  end

  def display
    current_node = @head

    while current_node.next?
      p current_node.data
      current_node = current_node.pointer
    end

    p current_node.data
  end
end

numbers = LinkedList.new(1)

(2..10).each {|x| numbers.push(x) }
# numbers.display

# numbers.reverse

# inc = 0
# numbers.each do |node|

#   # p node
#   # p "---"
#   if inc % 2 == 0
#     numbers.remove(node)
#   end
#   inc += 1
#   node
# end

p numbers.each {|node| p node;}

# numbers.display







