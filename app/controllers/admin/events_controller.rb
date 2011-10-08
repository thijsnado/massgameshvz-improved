class Admin::EventsController < AdminController
  
  def index
    if(@game = Game.current)
      @events = Event.joins(:game_participation).where(:game_participations => {:game_id => @game.id}).order('occured_at desc').includes(:game_participation => :user).paginate(:page => params[:page], :per_page => 15)
    else
      @events = Event.where("1 = 0").paginate(:page => params[:page], :per_page => 15)
    end
  end
  
end