class Admin::EventsController < AdminController
  
  def index
    @events = Event.joins(:game_participation).where(:game_participations => {:game_id => Game.current.id}).order('occured_at desc').includes(:game_participation => :user).paginate(:page => params[:page], :per_page => 15)
  end
  
end