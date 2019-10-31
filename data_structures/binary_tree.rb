class Node
  attr_reader :data
  attr_accessor :left, :right

  def initialize(data=nil)
    @data = data
    @left = nil
    @right = nil
  end

  def insert(value)
    # Recursively traversing until nil, then slots to left or right based on 
    # previous node's data.
    if value <= @data
      @left.nil? ? @left = Node.new(value) : @left.insert(value)
    elsif value > @data
      @right.nil? ? @right = Node.new(value) : @right.insert(value)
    end
  end
end

class BinarySearchTree
  def initialize(root_data=nil)
    @root = Node.new(root_data)
  end

  def insert(value)
    @root.insert(value)
  end

  def in_order(node=@root, &block)
    return if node.nil?
    in_order(node.left, &block)
    yield node
    in_order(node.right, &block)
  end

  def pre_order(node=@root, &block)
    return if node.nil?
    yield node
    in_order(node.left, &block)
    in_order(node.right, &block)
  end

  def post_order(node=@root, &block)
    return if node.nil?
    in_order(node.left, &block)
    in_order(node.right, &block)
    yield node
  end

  def search( value, node=@root )
    return nil if node.nil?
    if value < node.data
      search( value, node.left )
    elsif value > node.data
      search( value, node.right )
    else
      return node
    end
  end  

end

b = BinarySearchTree.new(1)
10.times do 
  val = (1..100).to_a.sample
  b.insert(val)
end

b.in_order do |node| 
  p "-------"
  p node.data
end

# p b.search(55)
# p b

