class Admin::MiscTasksController < AdminController
  
  
  def index
  end
  
  def pause_game_form
  end
  
  def pause_game
    unless Game.current.paused?
      ActiveRecord::Base.transaction do
        GameParticipation.lock
        Game.current.update_attributes(params[:game])
      end
    end
    flash[:notice] = "The game is paused until #{params[:game][:pause_ends_at]}"
    redirect_to admin_misc_tasks_url
  end
  
  def unpause_game
    if Game.current.paused?
      ActiveRecord::Base.transaction do
        GameParticipation.lock
        Game.current.unpause_game
      end
    end
    flash[:notice] = "The game has been unpaused"
    redirect_to admin_misc_tasks_url
  end
  
  def increase_zombie_expires_at
    Game.transaction do
      GameParticipation.transaction do
        Game.current.reward_zombies params[:hours]
      end
    end
    redirect_to admin_misc_tasks_url
  end

  def set_unassigned_to_human
    GameParticipation.update_all(["creature_type = 'Human', creature_id = ?", Human::NORMAL], ['creature_type is null AND game_id = ?', Game.current.id])
    redirect_to admin_misc_tasks_url
  end

  def resurrect_dead
    GameParticipation.update_all(['zombie_expires_at = ?', Time.now + Game.current.time_per_food], ['creature_type = "Zombie" AND game_id = ?', Game.current.id])
    redirect_to admin_misc_tasks_url
  end

end
