class GameParticipation < ActiveRecord::Base
  
  belongs_to :game
  belongs_to :user
  belongs_to :creature, :polymorphic => true
  belongs_to :living_area
  has_many :biting_events, :as => :responsible_object
  has_many :bitten_events, :class_name => 'BiteEvent'
  
  validate :validate_not_outside_signup_period
  validates_uniqueness_of :user_id, :scope => :game_id
  
  def validate_not_outside_signup_period
    unless Time.now.between? game.signup_start_at, game.signup_end_at or not new_record?
      errors.add(:game, "Signup period for this game has passed")
    end
  end
  
  def is_human?
    return !is_zombie?
  end
  
  def is_zombie?
    if creature_type == 'Zombie'
      return true
    else
      return false
    end
  end
  
  #Used when reporting who a user bit (A zombie reports he bit a human)
  def report_bite(user_participation)
    if is_zombie? && (user_participation.is_human? || user_participation.creature == Zombie::SELF_BITTEN)
      record_bite(user_participation)
      return true
    else
      return false
    end
  end
  
  #Used when reporting that a user got bitten (A human reports he got bit by a zombie)
  def report_bitten(user_participation)
    if is_human?
      user_participation.record_bite(self)
      return true
    else
      return false
    end
  end
  
  def record_bite(user_participation)
    time = Time.now
    if user_participation.is_human?
      user_participation.creature = Zombie::NORMAL
      user_participation.zombie_expires_at = time + game.time_per_food
      user_participation.save
      bite_event = BiteEvent.new
      bite_event.responsible_object = self
      bite_event.game_participation = user_participation
      bite_event.occured_at = time
      bite_event.save
      self.update_attribute :zombie_expires_at, bite_event.occured_at + self.game.time_per_food
    elsif user_participation.creature == Zombie::SELF_BITTEN
      user_participation.creature = Zombie::NORMAL
      user_participation.save
      bite_event = user_participation.bitten_events.order('occured_at desc').first
      bite_event.responsible_object = self
      bite_event.save
      if bite_event.occured_at + self.game.time_per_food > self.zombie_expires_at
        self.update_attribute :zombie_expires_at, bite_event.occured_at + self.game.time_per_food
      end
    end
  end
  
  def current_parent
    if is_zombie?
      return bitten_events.order('occured_at desc').first.biter_participation
    else
      return nil
    end
  end
  
  def is_expired
    return zombie_expires_at < Time.now 
  end
end
