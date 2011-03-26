class GamesController < ApplicationController
  # GET /games
  # GET /games.xml
  def index
    @game = Game.current
    @humans = Human.find(:all)
    @zombies = Zombie.find(:all)
    @living_areas = LivingArea.includes(:game_participations => :user)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @games }
    end
  end

end
