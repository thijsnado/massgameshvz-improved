class GamesController < ApplicationController
  # GET /games
  # GET /games.xml
  def index
    @game = Game.current
    @humans = Human.find(:all)
    @zombies = Zombie.find(:all)
    @human_count = @game.game_participations.humans.count
    @zombie_count = @game.game_participations.immortal_zombies.count + @game.game_participations.mortal_zombies.not_dead.count
    @dead_count = @game.game_participations.mortal_zombies.dead.count
    @unassigned_count = @game.game_participations.where('creature_type is null OR creature_type = ?', '').count
    @living_areas = LivingArea.includes(:game_participations => :user)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @games }
    end
  end

end
