class Inventory
  def initialize
    @items = []
  end

  def add_item(item)
    @items.push item
  end
end