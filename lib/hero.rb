class Hero < Character
  def initialize
    super('hero1.png')
    @inventory.add_item(Weapon.new('pistol', 40))
  end

  def button_down(id)
  end
  
  def update
    super
    move_right if Gosu::button_down?(Gosu::KB_RIGHT)
    move_left  if Gosu::button_down?(Gosu::KB_LEFT)
    move_up    if Gosu::button_down?(Gosu::KB_UP)
    move_down  if Gosu::button_down?(Gosu::KB_DOWN)
  end
end
