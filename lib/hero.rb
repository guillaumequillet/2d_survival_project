class Hero < Character
  @@keys = {
    up:      Gosu::KB_W,
    down:    Gosu::KB_S,
    left:    Gosu::KB_A,
    right:   Gosu::KB_D,
    aim:     Gosu::KB_SPACE,
    switch:  Gosu::KB_LEFT_CONTROL,
    shoot:   Gosu::KB_RETURN,
    run:     Gosu::KB_LEFT_SHIFT
  }

  # temp controller hack
  # PS1 keys
  # 0 => cross
  # 1 => circle
  # 2 => square
  # 3 => triangle
  # 4 => select
  # 6 => start
  # 7 => L3
  # 8 => R3
  # 9 => L1
  # 10 => R1
  # 11 => L2
  # 12 => R2
  @@keys = {
    up:      Gosu::GP_0_UP,
    down:    Gosu::GP_0_DOWN,
    left:    Gosu::GP_0_LEFT,
    right:   Gosu::GP_0_RIGHT,
    aim:     Gosu::GP_0_BUTTON_10,
    switch:  Gosu::GP_0_BUTTON_9,
    shoot:   Gosu::GP_0_BUTTON_0,
    run:     Gosu::GP_0_BUTTON_2
  }

  def initialize
    super('hero1.png')
    @inventory.add_item(Weapon.new('pistol', 40))
  end

  def button_down(id)
    # target change occurs on single presses
    if id == @@keys[:switch]
      @target_switching = true
    end
  end

  def update(ennemies)
    super()

    # running ?
    set_running(Gosu::button_down?(@@keys[:run]))

    # movement
    move_right if Gosu::button_down?(@@keys[:right])
    move_left  if Gosu::button_down?(@@keys[:left])
    move_up    if Gosu::button_down?(@@keys[:up])
    move_down  if Gosu::button_down?(@@keys[:down])

    # if the player triggers aiming and some ennemy is present
    if Gosu::button_down?(@@keys[:aim]) && !ennemies.empty?
      # we set the targeting action to true
      @targeting = true
      # if no target, we take the closest ennemy from hero
      if @target.nil?
        @target = ennemies.sort {|a, b| a.distance_from_hero <=> b.distance_from_hero}.first
      # if we are switching target, we take the NEXT closest ennemy
      elsif @target_switching
        sorted_array = ennemies.sort {|a, b| a.distance_from_hero <=> b.distance_from_hero}
        current_ennemy_index = sorted_array.index(@target)
        new_target_index = current_ennemy_index >= sorted_array.size - 1 ? 0 : current_ennemy_index + 1
        @target = sorted_array[new_target_index]
        # switching is a single button press operation
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
