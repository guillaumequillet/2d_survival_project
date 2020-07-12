class Character
  @@sprite_width = 24
  @@sprite_height = 32
  @@frame_count = 3
  @@frame_loop_order = [1, 2, 1, 0]
  @@frame_default = 0
  @@frame_duration = 200
  # variables to handle frames - TODO : add proper diagonal indexes
  @@directions = {
    north: 0,
    east: 1,
    south: 2,
    west: 3,
    north_east: 0,
    north_west: 0,
    south_east: 2,
    south_west: 2
  }
  @@direction_default = :north
  @@velocity = 1.5
  @@run_multiplier = 1.8

  attr_reader :position
  def initialize(spritesheet)
    @position = Position.new
    @velocity = @@velocity
    @running = false
    @inventory = Inventory.new
    @frames = Gosu::Image.load_tiles("./gfx/spritesheets/#{spritesheet}", @@sprite_width, @@sprite_height, retro: true) 
    @direction = @@direction_default
    @frame = @@frame_default
  end

  def set_position(x = 0, y = 0, z = 0)
    @position.x, @position.y, @position.z = x, y, z
    return self
  end

  def set_velocity(velocity)
    @velocity = velocity
    return self
  end

  def set_running(running)
    @running = running
    return self
  end

  def set_direction(direction)
    @direction = direction
    return self
  end

  def move(direction)
    set_direction(direction)
    velocity = @running ? @@run_multiplier * @velocity : @velocity 
    case @direction
    when :north
      @position.y -= velocity
    when :south
      @position.y += velocity
    when :east
      @position.x += velocity
    when :west
      @position.x -= velocity
    when :north_west
      @position.x -= velocity * 0.7
      @position.y -= velocity * 0.7
    when :north_east
      @position.x += velocity * 0.7
      @position.y -= velocity * 0.7
    when :south_west
      @position.x -= velocity * 0.7
      @position.y += velocity * 0.7
    when :south_east
      @position.x += velocity * 0.7
      @position.y += velocity * 0.7
    end
    @moving = true
  end

  def move_north
    move(:north)
  end

  def move_south
    move(:south)
  end

  def move_north_west
    move(:north_west)
  end

  def move_north_east
    move(:north_east)
  end

  def move_south_west
    move(:south_west)
  end

  def move_south_east
    move(:south_east)
  end

  def move_west
    move(:west)
  end
  
  def move_east
    move(:east)
  end

  def update
    if @moving
      if Gosu::milliseconds - @frame_tick >= @@frame_duration
        @frame += 1
        @frame = 0 if @frame >= @@frame_loop_order.size
        @frame_tick = Gosu::milliseconds
      end
      @moving = false
    else
      @frame_tick = Gosu::milliseconds
      @frame = @@frame_default
    end
  end

  def draw
    scale = 4
    current_frame_index = @@directions[@direction] * @@frame_count + @@frame_loop_order[@frame]    
    @frames[current_frame_index].draw_rot(@position.x, @position.y, @position.z + @position.y, 0, 0.5, 1, scale, scale)
  end
end