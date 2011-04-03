class EventsController < ApplicationController
  
  def index
    @top_zombies = GameParticipation.top_zombies.limit(5)
    @events = Event.joins(:game_participation).where(:game_participations => {:game_id => Game.current.id}).order('occured_at desc')
  end
  
end