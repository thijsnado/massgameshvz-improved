class BiteShare < ActiveRecord::Base
  belongs_to :bite_event
  belongs_to :game_participation
  belongs_to :shared_with, :class_name => 'GameParticipation'
  
  def self.not_used
    where(:used => false)
  end
  
  def share(game_participation)
    game_participation.zombie_expires_at = self.bite_event.zombie_expiration_calculation 
    game_participation.save
    self.used = true
    self.shared_with = game_participation
    self.save
    bite_share_event = BiteShareEvent.new
    bite_share_event.game_participation = self.game_participation
    bite_share_event.target_object = self
    bite_share_event.occured_at = Time.now
    bite_share_event.save
  end
end
