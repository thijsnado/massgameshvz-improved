class EventsController < ApplicationController
  
  def index
    @game = Game.current
    if @game && stale?(:etag => @game, :last_modified => @game.updated_at)
      show_game
      render :action => 'show'
    else
      @games = Game.order('end_at desc')
    end
  end
  
  def show
    @game = Game.find(params[:id])
    if stale?(:etag => @game, :last_modified => @game.updated_at)
      show_game
    end
  end
  
  def show_game
    @game ||= Game.find(params[:id])
    @top_zombies = @game.game_participations.top_zombies.limit(5).includes(:user)
    @events = Event.joins(:game_participation).where(:game_participations => {:game_id => @game.id}).order('occured_at desc').includes(:game_participation => :user).paginate(:page => params[:page], :per_page => 15)
  end
  
  def _show
    redirect_to event_url(params[:id])
  end
  
end