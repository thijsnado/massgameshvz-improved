class Admin::GamesController < AdminController
  def index
    @games = Game.all
  end

  def show
    @game = Game.find(params[:id])
  end
  
  def edit
    @game = Game.find(params[:id])
  end
  
  def new
    @game = Game.new
  end
  
  def create
    @game = Game.new(params[:game])
    if @game.save
      redirect_to admin_games_url
    else
      render :action => 'new'
    end
  end

  def update
    @game = Game.find(params[:id])
    if @game.update_attributes(params[:game])
      redirect_to admin_games_url
    else
      render :action => 'edit'
    end
  end

end
