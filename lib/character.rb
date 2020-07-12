class Character
  @@sprite_width = 24
  @@sprite_height = 32
  @@velocity = 4

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
  end

  def set_velocity(velocity)
    @velocity = velocity
  end

  def move_up
    @position.y -= @velocity
  end

  def move_down
    @position.y += @velocity
  end

  def move_left
    @position.x -= @velocity
  end
  
  def move_right
    @position.x += @velocity
  end

  def update
  
  end

  def draw
    scale = 4
    current_frame_index = @directions[@direction] * @frame_count + @frame
    @frames[current_frame_index].draw_rot(@position.x, @position.y, @position.z, 0, 0.5, 1, scale, scale)
  end
end