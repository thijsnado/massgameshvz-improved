class Admin::MiscTasksController < AdminController
  
  
  def index
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
