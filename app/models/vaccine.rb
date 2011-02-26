class Vaccine < ActiveRecord::Base
  
  def take(game_participation)
    if takable(game_participation)
      game_participation.creature = Human::NORMAL
      game_participation.save
      self.used = true
      self.save
    end
  end
  
  private
  
  def takable(game_participation)
    takable = true
    #vaccine cant be used
    takable = takable && !self.used
    #creature must be vaccinatable zombie
    takable = takable && game_participation.creature.vaccinatable rescue false
    return takable
  end
  
end
