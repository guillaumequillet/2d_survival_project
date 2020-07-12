class Hero < Character
  def initialize
    super('hero1.png')
    @inventory.add_item(Weapon.new('pistol', 40))
  end
end
