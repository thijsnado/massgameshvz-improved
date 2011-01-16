class GamesController < ApplicationController
  # GET /games
  # GET /games.xml
  def index
    @game = Game.current
    @humans = Human.find(:all)
    @zombies = Zombie.find(:all)
    @living_areas = LivingArea.includes(:game_participations => :user)
    if @game  
      @living_areas = @living_areas.where(
        :game_participations => {:game_id => @game.id}
      )
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @games }
    end
  end

  # GET /games/1
  # GET /games/1.xml
  def show
    @game = Game.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @game }
    end
  end

end
