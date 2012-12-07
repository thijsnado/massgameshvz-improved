class Admin::OriginalZombiesController < AdminController
  def index
    @game_participations = OriginalZombiesReport.original_zombies_and_zombie_requests
  end

  def show

  end

  def make_zombie
    @game_participation = GameParticipation.find(params[:id])
    @game_participation.creature = Zombie::ORIGINAL
    @game_participation.save
    redirect_to admin_original_zombies_url
  end

  def make_regular
    @game_participation = GameParticipation.find(params[:id])
    @game_participation.creature = Human::NORMAL
    @game_participation.save
    redirect_to admin_original_zombies_url
  end

end
