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
    @hero = Hero.new
    @hero.set_position(self.width/2, self.height/2, 0)
    @skeleton = Ennemy.new('skeleton.png')
    @skeleton.set_position(100, 100, 0)
    @skeleton2 = Ennemy.new('skeleton.png')
    @skeleton2.set_position(400, 400, 0)
  end 

  def button_down(id)
    super
    close! if id == Gosu::KB_ESCAPE
  end

  def needs_cursor?; true; end

  def update

  end

  def draw
    @hero.draw
    @skeleton.draw
    @skeleton2.draw
  end
end

Window.new.show
