class EventsController < ApplicationController
  
  def index
    @top_zombies = GameParticipation.top_zombies.limit(5).includes(:user)
    @events = Event.joins(:game_participation).where(:game_participations => {:game_id => Game.current.id}).order('occured_at desc').includes(:game_participation => :user).paginate(:page => params[:page], :per_page => 15)
  end
  
end