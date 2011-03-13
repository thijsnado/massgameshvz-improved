class GameParticipation < ActiveRecord::Base
  
  belongs_to :game
  belongs_to :user
  belongs_to :creature, :polymorphic => true
  belongs_to :living_area
  has_many :biting_events, :as => :responsible_object, :class_name => 'BiteEvent'
  has_many :bitten_events, :class_name => 'BiteEvent'
  has_many :bite_shares, :through => :biting_events
  
  validate :validate_not_outside_signup_period
  validates_uniqueness_of :user_id, :scope => :game_id
  
  def self.zombie
    where(:creature_type => 'Zombie')
  end
  
  def self.not_immortal
    joins("INNER JOIN zombies on game_participations.creature_id = zombies.id").where(:zombies => {:immortal => false})
  end
  
  def self.not_dead
    where("zombie_expires_at > ?", Time.now)
  end
  
  def validate_not_outside_signup_period
    unless Time.now.between? game.signup_start_at, game.signup_end_at or not new_record?
      errors.add(:game, "Signup period for this game has passed")
    end
  end
  
  def human?
    return creature_type == 'Human'
  end
  
  def zombie?
    return creature_type == 'Zombie'
  end
  
  #Used when reporting who a user bit (A zombie reports he bit a human)
  def report_bite(game_participation)
    if zombie? && (game_participation.human? || game_participation.creature == Zombie::SELF_BITTEN)
      record_bite(game_participation)
      return true
    else
      return false
    end
  end
  
  #Used when reporting that a user got bitten (A human reports he got bit by a zombie)
  def report_bitten(game_participation)
    if human?
      game_participation.record_bite(self)
      return true
    else
      return false
    end
  end
  
  def current_parent
    if zombie?
      return bitten_events.order('occured_at desc').first.biter_participation
    else
      return nil
    end
  end
  
  def is_expired
    return self.zombie_expires_at < Time.now unless self.creature.immortal
    return false
  end
  
  def zombification_event
    self.bitten_events.first
  end
  
  protected
  
  def record_bite(game_participation)
    time = Time.now
    
    #adjust starvation time
    if game_participation.human?
      game_participation.creature = Zombie::NORMAL
      game_participation.zombie_expires_at = time + self.game.time_per_food
      game_participation.save
      self.zombie_expires_at = time + self.game.time_per_food
    elsif game_participation.creature == Zombie::SELF_BITTEN
      game_participation.creature = Zombie::NORMAL
      game_participation.save
      zombie_expires_at = game_participation.zombification_event.zombie_expiration_calculation
      self.zombie_expires_at = zombie_expires_at unless zombie_expires_at < self.zombie_expires_at
    end
    
    #record bite event
    bite_event = BiteEvent.new
    bite_event.responsible_object = self
    bite_event.game_participation = game_participation
    bite_event.occured_at = time
    bite_event.zombie_expiration_calculation = self.zombie_expires_at
    bite_event.save
    
    #create bite shares
    game.bite_shares_per_food.times do
      bite_share = BiteShare.new
      bite_share.bite_event = bite_event
      bite_share.save
    end
    
    #handle different creature types
    if self.human?
      self.creature = Zombie::SELF_BITTEN
    end
    save
  end
end
