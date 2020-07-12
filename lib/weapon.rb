class Weapon < Item
  def initialize(name, range)
    super(name)
    @range = range
  end
end