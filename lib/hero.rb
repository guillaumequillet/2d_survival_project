class Hero < Character
  def initialize
    super('hero1.png')
    @inventory.add_item(Weapon.new('pistol', 40))
  end

  def button_down(id)
    # target change occurs on single presses
    if id == Gosu::KB_LEFT_CONTROL
      @target_switching = true
    end
  end

  def update(ennemies)
    super()
    # movement
    move_right if Gosu::button_down?(Gosu::KB_RIGHT)
    move_left  if Gosu::button_down?(Gosu::KB_LEFT)
    move_up    if Gosu::button_down?(Gosu::KB_UP)
    move_down  if Gosu::button_down?(Gosu::KB_DOWN)

    # target
    if Gosu::button_down?(Gosu::KB_SPACE)
      @targeting = true
      if @target.nil?
        @target = ennemies.sort {|a, b| a.distance_from_hero <=> b.distance_from_hero}.first
      elsif @target_switching
        sorted_array = ennemies.sort {|a, b| a.distance_from_hero <=> b.distance_from_hero}
        current_ennemy_index = sorted_array.index(@target)
        new_target_index = current_ennemy_index >= sorted_array.size - 1 ? 0 : current_ennemy_index + 1
        @target = sorted_array[new_target_index]
        @target_switching = false
      end
    else 
      @target = nil
      @targeting = false
    end
  end

  def draw
    super()

    if @targeting
      @font ||= Gosu::Font.new(24)
      @font.draw_text('targeting', @position.x, @position.y + @font.height, 1)
      unless @target.nil?
        Gosu::draw_line(@position.x, @position.y - 48, Gosu::Color::RED, @target.position.x, @target.position.y - 48, Gosu::Color::RED)
      end
    end
  end
end
