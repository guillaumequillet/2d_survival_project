class Character
  @@sprite_width = 24
  @@sprite_height = 32
  @@frame_count = 3
  @@frame_loop_order = [1, 2, 1, 0]
  @@frame_default = 0
  @@frame_duration = 200
  @@velocity = 1.5

  attr_reader :position
  def initialize(spritesheet)
    @position = Position.new
    @velocity = @@velocity
    @inventory = Inventory.new
    @frames = Gosu::Image.load_tiles("./gfx/spritesheets/#{spritesheet}", @@sprite_width, @@sprite_height, retro: true)
    
    # variables to handle frames
    @directions = {
      north: 0,
      east: 1,
      south: 2,
      west: 3
    }
    @direction = :north
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

  def set_direction(direction)
    @direction = direction
    return self
  end

  def move(direction)
    set_direction(direction)
    case @direction
    when :north
      @position.y -= @velocity
    when :south
      @position.y += @velocity
    when :east
      @position.x += @velocity
    when :west
      @position.x -= @velocity
    end
    @moving = true
  end

  def move_up
    move(:north)
  end

  def move_down
    move(:south)
  end

  def move_left
    move(:west)
  end
  
  def move_right
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
    current_frame_index = @directions[@direction] * @@frame_count + @@frame_loop_order[@frame]
    @frames[current_frame_index].draw_rot(@position.x, @position.y, @position.z + @position.y, 0, 0.5, 1, scale, scale)
  end
end