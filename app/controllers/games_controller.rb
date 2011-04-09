class GamesController < ApplicationController
  # GET /games
  # GET /games.xml
  def index
    @game = Game.current
    
    if @game
      show
      render :action => 'show'
    else
      @games = Game.order('end_at desc')
    end
  end
  
  def show
    @game ||= Game.find(params[:id])
    @humans = Human.find(:all)
    @zombies = Zombie.find(:all)
    @human_count = @game.game_participations.humans.count
    @zombie_count = @game.game_participations.immortal_zombies.count + @game.game_participations.mortal_zombies.not_dead.count
    @dead_count = @game.game_participations.mortal_zombies.dead.count
    @total_count = @human_count + @zombie_count + @dead_count
    @living_areas = LivingArea.includes(:game_participations => :user).where(:game_participations => {:game_id => @game.id})
    @dead_participations = @game.game_participations.dead.includes(:user)
    @is_current_game = Game.current && @game == Game.current
  end
  
  def _show
    redirect_to game_url(params[:id])
  end

end
