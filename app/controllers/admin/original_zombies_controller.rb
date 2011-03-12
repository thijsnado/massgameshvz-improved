class Admin::OriginalZombiesController < AdminController
  def index
    @users = User.original_zombies_and_zombie_requests
  end
  
  def show
    
  end

  def make_zombie
    @user = User.find(params[:id])
    @user.creature_type = 'Zombie'
    @user.creature_id = Zombie::DEFAULT_TYPES[:original_zombie]
    @user.save
    redirect_to admin_original_zombies_url
  end
  
  def make_regular
    @user = User.find(params[:id])
    @user.creature_type = 'Human'
    @user.creature_id = Human::DEFAULT_TYPES[:normal]
    @user.save
    redirect_to admin_original_zombies_url
  end

end
