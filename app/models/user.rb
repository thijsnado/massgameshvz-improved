class User < ActiveRecord::Base
  has_many :game_participations
  
  attr_accessor :password
  attr_accessor :password_confirmation
  attr_accessor :rules_read
  
  def is_human
    return !is_zombie
  end
  
  def is_zombie
    if current_participation.creature_type == 'Zombie'
      return true
    else
      return false
    end
  end
  
  def current_participation
    @current_participation ||= Game.current.game_participations.find_by_user_id(id)
  end
  
  def report_bite(user)
    if is_zombie
      user.zombify
      add_food
    else
      
    end
  end
  
end
