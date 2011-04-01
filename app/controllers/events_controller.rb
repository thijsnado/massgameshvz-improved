class EventsController < ApplicationController
  
  def index
    @events = Event.joins(:game_participation).where(:game_participations => {:game_id => Game.current.id}).order('occured_at desc')
  end
  
end