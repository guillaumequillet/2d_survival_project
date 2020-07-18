class Ennemy < Character
  attr_reader :distance_from_hero
  def initialize(filename)
    super(filename)
  end

  def update_distance_from_hero(hero)
    @distance_from_hero = Gosu::distance(@position.x, @position.y, hero.position.x, hero.position.y).floor
  end

  def update(hero)
    super()
    update_distance_from_hero(hero)

    # TEMP - random movement
    @timer ||= 0
    @timer += (rand()*10 + 1).floor

    if (@timer >= 500)
      set_direction([:north, :east, :west, :south].sample)
      @timer = 0
    end

    move(@direction)
    # END TEMP - random movement
  end

  def draw
    super()
    @font ||= Gosu::Font.new(12)
    @font.draw_text(@distance_from_hero, @position.x, @position.y + @font.height, 1)
  end
end