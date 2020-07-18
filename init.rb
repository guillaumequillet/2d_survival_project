=begin
  on a un personnage qui a une position
  on veut cibler l'ennemi le plus proche
  on veut afficher une range insuffisante via la couleur du faisceau ou un indicateur "cible barrée" par exemple
  on veut permettre de changer de cible
  on veut tenir compte des murs

  on a donc besoin :
  - d'un personnage avec des coordonnées OK
  - d'ennemis avec des coordonnées OK
  - d'inventaire (pour les persos ET les drop) OK
  - de propriétés d'arme (portée) OK
  - d'une map (murs)

  on voit pouvoir :
  - calculer une distance (Gosu::distance...)
  - définir s'il y a collision avec un mur, et la distance par rapport à cette collision
=end

require 'gosu'
require_relative './lib/position.rb'
require_relative './lib/character.rb'
require_relative './lib/hero.rb'
require_relative './lib/ennemy.rb'
require_relative './lib/inventory.rb'
require_relative './lib/item.rb'
require_relative './lib/weapon.rb'

class Window < Gosu::Window
  def initialize
    super(640, 480, false)
    @scale = 4
    @hero = Hero.new.set_map_position(10, 8).set_velocity(0.6)
    @ennemies = []
    5.times do
      x = (rand * 20).floor
      y = (rand * 15).floor
      @ennemies.push Ennemy.new('skeleton.png').set_map_position(x, y)
    end
  end 

  def button_down(id)
    super
    close! if id == Gosu::KB_ESCAPE
    @hero.button_down(id)
  end

  def button_up(id)
    super
    @hero.button_up(id)
  end

  def needs_cursor?; true; end

  def update
    @hero.update(@ennemies)
    @ennemies.each {|ennemy| ennemy.set_velocity(0.25); ennemy.update(@hero)}
    self.caption = @hero.map_target.inspect
  end

  def draw
    tile_size = 16
    @tile ||= Gosu::render(tile_size, tile_size, retro: true) do
      Gosu::draw_rect(0, 0, tile_size, tile_size, Gosu::Color.new(255, 64, 64, 64))
      Gosu::draw_rect(1, 1, 15, 15, Gosu::Color.new(255, 128, 128, 128))
    end
    scale(@scale, @scale) do
      15.times do |y|
        20.times do |x|
          @tile.draw(x * tile_size, y * tile_size, 0)
        end
      end
      @hero.draw
      @ennemies.each {|ennemy| ennemy.draw}
    end
  end
end

Window.new.show
