class GameParticipationsController < ApplicationController
  
  def ask_about_game_registration
  end
  
  def create
    @game_participation = current_game.game_participations.new(params[:game_participation])
    @game_participation.user = current_user
    if @game_participation.save
      redirect_to(root_url, :notice => 'You have registered, please check email for confirmation')
    else
      redirect_to(new_game_participation_url, :notice => 'Something went wrong, make sure you fill out all fields')
    end
  end
  
  def new
    @game_participation = current_game.game_participations.new
    @living_areas = LivingArea.all
  end
  
end
