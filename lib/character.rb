class Character
  @@tile_size = 16
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
  @@velocity = 1
  @@run_multiplier = 2

  attr_reader :position, :map_position, :map_target
  def initialize(spritesheet, sprite_width = nil, sprite_height = nil)
    @position = Position.new
    @map_position = Position.new
    @map_target = nil
    @velocity = @@velocity
    @running = false
    @inventory = Inventory.new
    @frames = Gosu::Image.load_tiles("./gfx/spritesheets/#{spritesheet}", sprite_width.nil? ? @@sprite_width : sprite_width, sprite_height.nil? ? @@sprite_height : sprite_height, retro: true) 
    @direction = @@direction_default
    @frame = @@frame_default
    @frame_tick = Gosu::milliseconds
  end

  def set_map_position(x, y)
    @map_position.x, @map_position.y = x, y
    set_position((@map_position.x + 0.5) * @@tile_size, (@map_position.y + 0.5) * @@tile_size, 0)
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
    # we can only move if previous target was reached (aka == nil)
    if @map_target.nil?
      set_direction(direction)
      @map_target = Position.new(@map_position.x, @map_position.y, 0)
      case direction
      when :north
        @map_target.y -= 1
      when :south
        @map_target.y += 1
      when :east
        @map_target.x += 1
      when :west
        @map_target.x -= 1
      end
    end
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

  def stop_movement
    if @map_target.nil?
      @frame_tick = Gosu::milliseconds
      @frame = @@frame_default
    end
  end

  def update
    velocity = @running ? @@run_multiplier * @velocity : @velocity 

    unless @map_target.nil?
      target_x = (@map_target.x + 0.5) * @@tile_size
      target_y = (@map_target.y + 0.5) * @@tile_size

      if @position.x < target_x
        @position.x += velocity
        @position.x = target_x if @position.x > target_x
      elsif @position.x > target_x
        @position.x -= velocity
        @position.x = target_x if @position.x < target_x
      elsif @position.y < target_y
        @position.y += velocity
        @position.y = target_y if @position.y > target_y
      elsif @position.y > target_y
        @position.y -= velocity
        @position.y = target_y if @position.y < target_y
      end
  
      # if we reached the target
      if @position.x == target_x && @position.y == target_y
        # we adjust the map position according to pixel position
        @map_position.x = (@position.x / @@tile_size.to_f).floor
        @map_position.y = (@position.y / @@tile_size.to_f).floor
        @moving = false
        @map_target = nil
      # if we didn't reach the target
      else
        @moving = true
      end
    end

    if @moving
      if Gosu::milliseconds - @frame_tick >= @@frame_duration / (@running ? @@run_multiplier : 1)
        @frame += 1
        @frame = 0 if @frame >= @@frame_loop_order.size
        @frame_tick = Gosu::milliseconds
      end
    end
  end

  def draw
    current_frame_index = @@directions[@direction] * @@frame_count + @@frame_loop_order[@frame]    
    @frames[current_frame_index].draw_rot(@position.x, @position.y, @position.z + @position.y, 0, 0.5, 1)
  end
end