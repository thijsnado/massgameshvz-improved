class OriginalZombiesReport
  def initialize(game = Game.current)
    @game = game || Game.new
  end

  def original_zombies_and_original_zombie_requests
    GameParticipation.where(
      %Q{
        game_participations.id in (#{original_zombies.select('game_participations.id').to_sql}) OR
        game_participations.id in (#{original_zombie_requests_not_zombies.select('game_participations.id').to_sql})
      }
    )
  end

  private

  def original_zombies
    game_participations.joins_with_zombie.where(:zombies => {:id => Zombie::ORIGINAL.id})
  end

  def original_zombie_requests_not_zombies
    original_zombie_requests.where("creature_type != 'Zombie' OR creature_type is null")
  end

  def game_participations
    @game.game_participations
  end

  def original_zombie_requests
    game_participations.where(:original_zombie_request => true)
  end

end
