class Character
  @@sprite_width = 24
  @@sprite_height = 32
  @@velocity = 1

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
    @frame = 0
    @frame_count = 1
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
    
  end

  def draw
    scale = 4
    current_frame_index = @directions[@direction] * @frame_count + @frame
    @frames[current_frame_index].draw_rot(@position.x, @position.y, @position.z + @position.y, 0, 0.5, 1, scale, scale)
  end
end