class BiteShare < ActiveRecord::Base
  belongs_to :bite_event
  belongs_to :game_participation
  
  
  def share(game_participation)
    game_participation.zombie_expires_at = self.bite_event.zombie_expiration_calculation 
    game_participation.save
  end
end
