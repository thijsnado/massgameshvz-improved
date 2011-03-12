class Admin::MiscTasksController < AdminController
  def index
  end

  def set_unassigned_to_human
    User.update_all(["creature_type = 'Human', creature_id = ?", Human::DEFAULT_TYPES[:normal]], 'creature_type is null')
    redirect_to admin_misc_tasks_url
  end

  def resurrect_dead
    ZombieExpirationDate.update_all(['death_date = ?', Zombie.value_of_food])
    redirect_to admin_misc_tasks_url
  end

end
