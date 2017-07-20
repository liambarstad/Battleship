require './lib/player'

class Ai < Player
  attr_accessor :placer, :attacker
  def initialize(size, player, difficulty)
    super(size)
    @player = player
    @difficulty = difficulty
    @placer = AiPlacer.new(size, player)
    @attacker = AiAttacker.new(size, player, difficulty)
  end

  def last_guess
    @attacker.last_guess
  end

  def last_result
    @attacker.last_result
  end

  def place_ships
    @placer.place_ships
  end

  def attack
    @attacker.attack
  end
end
