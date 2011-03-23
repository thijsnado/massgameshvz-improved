class Admin::EventsController < AdminController
  
  def index
    @events = Event.joins(:game_participation).where(:game_participations => {:game_id => Game.current.id})
  end
  
end