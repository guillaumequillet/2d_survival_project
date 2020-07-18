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
    super('jill.png', 32, 32)
    @aiming_sprites = Gosu::Image.load_tiles('gfx/spritesheets/jill_aiming.png', 32, 32, retro: true)
    @inventory.add_item(Weapon.new('pistol', 40))
  end

  def button_down(id)
    # target change occurs on single presses
    if id == @@keys[:switch]
      @target_switching = true
    end
  end

  def button_up(id)
    
  end

  def update(ennemies)
    super()

    # if the player is still and triggers aiming while some ennemy is present
    if @map_target.nil? && Gosu::button_down?(@@keys[:aim]) && !ennemies.empty?
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

    unless @targeting
      # running ?
      set_running(Gosu::button_down?(@@keys[:run]))

      # movement
      if Gosu::button_down?(@@keys[:up])
        move(:north) 
      elsif Gosu::button_down?(@@keys[:down])
        move(:south) 
      elsif Gosu::button_down?(@@keys[:left])
        move(:west) 
      elsif Gosu::button_down?(@@keys[:right])
        move(:east) 
      else
        stop_movement
      end
    end
  end

  def draw
    unless (@target.nil?)
      # we want to adjust the direction to face the target, if any
      angle = Gosu::angle(@position.x, @position.y, @target.position.x, @target.position.y)

      if angle >= 45 && angle < 135
        @direction = :east
      elsif angle >= 135 && angle < 225
        @direction = :south
      elsif angle >= 225 && angle < 315
        @direction = :west
      elsif angle >= 315 || angle < 45
        @direction = :north
      end
    end
    
    current_frame_index = @@directions[@direction] * @@frame_count + @@frame_loop_order[@frame] 
    sprites = @targeting ? @aiming_sprites : @frames   
    sprites[current_frame_index].draw_rot(@position.x, @position.y, @position.z + @position.y, 0, 0.5, 1)

    if @targeting
      @font ||= Gosu::Font.new(12)
      @font.draw_text('targeting | angle : ' + angle.round(0).to_s, @position.x, @position.y + @font.height, 1)
      unless @target.nil?
        src = Position.new(@position.x, @position.y - 12, @position.z)
        src.x += 8 if @direction == :east
        src.x -= 8 if @direction == :west
        Gosu::draw_line(src.x, src.y, Gosu::Color::RED, @target.position.x, @target.position.y - 16, Gosu::Color::RED)
      end
    end
  end
end
